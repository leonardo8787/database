#include "control_insert.hpp"

ControlInsert::ControlInsert() {}
ControlInsert::~ControlInsert() {}

void ControlInsert::setMysql(MYSQL *mysql) { this->mysql = mysql; }
void ControlInsert::setUtil(Util *util) { this->util = util; }

MYSQL *ControlInsert::getMysql() { return this->mysql; }
Util *ControlInsert::getUtil() { return this->util; }

/**
 * @brief testeQuery testa a query informada
 *
 * @param query
 * @return int -1 = query invalida
 * 				1 = query executada com sucesso
 * 				0 = nenhuma linha afetada
 */
int ControlInsert::testQuery(string query) {
	if (mysql_query(getMysql(), query.c_str()) != 0) return -1;
	else if (mysql_affected_rows(getMysql()) != 0) return 1;
	return 0;
}

void ControlInsert::adicionarIngrediente() {
	string nome;
	string query;

	cout << "Informe o nome do ingrediente: ";
	cin.ignore();
	getline(cin, nome);
	nome = getUtil()->testSqlInjection(getMysql(), nome);

	query.assign("insert INTO ingredientes (nome) VALUES ('").append(nome).append("');");

	if (mysql_query(getMysql(), query.c_str()) != 0)
		cout << "Ops... nao foi possivel cadastrar o ingrediente " << nome << "." << endl;
	else
		cout << "O ingrediente " << nome << " foi cadastrado com sucesso" << endl;
}

void ControlInsert::adicionarUsuario() {
	string nome;
	string telefone;
	string email;
	string cidade;
	string estado;
	string foto;

	string query;

	cout << "Informe o nome do Usuario: ";
	cin.ignore();
	getline(cin, nome);
	nome = getUtil()->testSqlInjection(getMysql(), nome);

	cout << "Informe o telefone: ";
	getline(cin, telefone);
	telefone = getUtil()->testSqlInjection(getMysql(), telefone);

	cout << "Informe o email: ";
	getline(cin, email);
	email = getUtil()->testSqlInjection(getMysql(), email);

	cout << "Informe a cidade: ";
	getline(cin, cidade);
	cidade = getUtil()->testSqlInjection(getMysql(), cidade);

	cout << "Informe o estado: ";
	getline(cin, estado);
	estado = getUtil()->testSqlInjection(getMysql(), estado);

	cout << "Informe a foto: ";
	getline(cin, foto);
	foto = getUtil()->testSqlInjection(getMysql(), foto);

	query.assign("insert INTO usuarios (nome, telefone, email, cidade, estado, foto) VALUES ")
		.append("('").append(nome).append("','")
		.append(telefone).append("','")
		.append(email).append("','")
		.append(cidade).append("','")
		.append(estado).append("','")
		.append(foto).append("');");

	if (mysql_query(getMysql(), query.c_str()) != 0)
		cout << "Ops... nao foi possivel cadastrar o usuario " << nome << "." << endl;
	else {
		cout << "O usuario " << nome << " foi cadastrado com sucesso" << endl;
		adicionarCredencial();
	}

}

void  ControlInsert::adicionarCredencial() {
	string query = "select * from usuarios";
	string credencial, id;

	cout << endl;
	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
		cout << "\nInforme o id do usario para adicionar a credencial: ";
		getline(cin, id);
		id = getUtil()->testSqlInjection(getMysql(), id);

		cout << "Informe a credencial: ";
		getline(cin, credencial);
		credencial = getUtil()->testSqlInjection(getMysql(), credencial);

		string query = "insert into credenciais (id, senha) values ";
		query.append("(").append(id).append(", '")
			.append(credencial).append("')");

		if (mysql_query(getMysql(), query.c_str()) != 0)
			cout << "Ops... nao foi possivel cadastrar a credencial no usuario" << endl;
		else
			cout << "A credencial foi cadastrada" << endl;
	}
}

void ControlInsert::adicionarReceita(string id_usuario) {
	string nome;
	string rendimento;
	string tempo;

	string query;

	cout << "Informe o nome da receita: ";
	cin.ignore();
	getline(cin, nome);
	nome = getUtil()->testSqlInjection(getMysql(), nome);

	cout << "Informe o rendimento: ";
	getline(cin, rendimento);
	rendimento = getUtil()->testSqlInjection(getMysql(), rendimento);

	cout << "Informe o tempo: ";
	getline(cin, tempo);
	tempo = getUtil()->testSqlInjection(getMysql(), tempo);

	query.assign("insert INTO receitas (usuario_id, nome, rendimento, tempo) VALUES ")
		.append("(").append(id_usuario).append(",'")
		.append(nome).append("','")
		.append(rendimento).append("','")
		.append(tempo).append("');");

	if (mysql_query(getMysql(), query.c_str()) != 0)
		cout << "Ops... nao foi possivel cadastrar a receita " << nome << "." << endl;
	else
		cout << "A receita " << nome << " foi cadastrado com sucesso" << endl;

}


/*
[Thomás]:

- Dando erro ao cadastrar
* Arrumar como é passado o id da Receita,
* Se der certo criar opção de adicionar mais ingredientes à receita
*/
void ControlInsert::adicionarIngredienteReceitas() {
	string query = "select id, nome from receitas";
	getUtil()->imprimeDados(getMysql(), query.c_str());

	string id_ingrediente;
	string id_receita;
	string quantidade;
	string unidade;

	cout << "\nInforme id da receita: ";
	cin.ignore();
	getline(cin, id_receita);
	id_receita = getUtil()->testSqlInjection(getMysql(), id_receita);

	query.assign("select * from receitas where id = ").append(id_receita);

	mysql_query(getMysql(), query.c_str());
	MYSQL_RES *resultado = mysql_store_result(mysql);

	if (resultado == NULL) {
		cout << "Query invalida" << endl;
		return;
	} else if (mysql_affected_rows(mysql) == 0) {
		cout << "Empty set" << endl;
		return;
	}

	cout << endl << "[Adicionando Ingredientes à receita]" << endl << endl;

	query = "select * from ingredientes";
	getUtil()->imprimeDados(getMysql(), query.c_str());

	cout << "\nInforme o id do ingrediente: ";
	// cin.ignore();
	getline(cin, id_ingrediente);
	id_ingrediente = getUtil()->testSqlInjection(getMysql(), id_ingrediente);

	query.assign("select * from ingredientes where id = ").append(id_ingrediente);

	mysql_query(getMysql(), query.c_str());
	resultado = mysql_store_result(mysql);

	// verifica se a query eh invalida ou se encontrou o id informado
	if (resultado == NULL) {
		cout << "Query invalida" << endl;
		return;
	} else if (mysql_affected_rows(mysql) == 0) {
		cout << "Ingrediente nao encontrado" << endl;
		return;
	}

	cout << "Informe a quantidade: ";
	getline(cin, quantidade);
	quantidade = getUtil()->testSqlInjection(getMysql(), quantidade);

	cout << "Informe a unidade: ";
	getline(cin, unidade);
	unidade = getUtil()->testSqlInjection(getMysql(), unidade);

	query.assign("insert INTO receitas_ingredientes(receita_id, ingrediente_id, quantidade, unidade) VALUES ")
		.append("(").append(id_receita).append(",")
		.append(id_ingrediente).append(",")
		.append(quantidade).append(",'")
		.append(unidade).append("')");

	if (mysql_query(getMysql(), query.c_str()) != 0)
		cout << "Ops... nao foi possivel cadastrar ingrediente à receita." << endl;
	else
		cout << "O ingrediente foi cadastrado na receita com sucesso" << endl;
}

/*
[Thomás] - adicionarEtapasReceita()

- adicionar função no menu;
- conferir se ta funcionando corretamente
- Esta na opção 18 no Menu Gerenciamento
*/

void ControlInsert::adicionarEtapasReceita() {
	string query = "select id, nome from receitas";
	getUtil()->imprimeDados(getMysql(), query.c_str());

	string numero_etapa;
	string id_receita;
	string titulo;

	cout << "\nInforme id da receita: ";
	cin.ignore();
	getline(cin, id_receita);
	id_receita = getUtil()->testSqlInjection(getMysql(), id_receita);

	query.assign("select * from receitas where id = ").append(id_receita);

	mysql_query(getMysql(), query.c_str());
	MYSQL_RES *resultado = mysql_store_result(mysql);

	if (resultado == NULL) {
		cout << "Query invalida" << endl;
		return;
	} else if (mysql_affected_rows(mysql) == 0) {
		cout << "Empty set" << endl;
		return;
	}

	query.assign("select numero, titulo from receitas_etapas where receita_id = ").append(id_receita);
	getUtil()->imprimeDados(getMysql(), query.c_str());

	cout << "\nInforme o numero da etapa: ";
	getline(cin, numero_etapa);
	numero_etapa = getUtil()->testSqlInjection(getMysql(), numero_etapa);

	cout << "\nInforme o titulo da etapa: ";
	getline(cin, titulo);
	titulo = getUtil()->testSqlInjection(getMysql(), titulo);

	cout << endl << "[Adicionando Etapa à receita]" << endl << endl;

	query.assign("insert INTO receitas_etapas(receita_id, numero, titulo) VALUES ")
		.append("(").append(id_receita).append(",")
		.append(numero_etapa).append(",'")
		.append(titulo).append("')");

	if (mysql_query(getMysql(), query.c_str()) != 0)
		cout << "Ops... nao foi possivel cadastrar etapa à receita." << endl;
	else
		cout << "A etapa foi cadastrada etapa na receita com sucesso" << endl;
}

void ControlInsert::adicionarPassoNaEtapa() {
	string query = "select id, nome from receitas";

	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {

		string numero_etapa;
		string id_receita;
		// string titulo;

		cout << "\nInforme id da receita: ";
		cin.ignore();
		getline(cin, id_receita);
		id_receita = getUtil()->testSqlInjection(getMysql(), id_receita);

		query.assign("select id from receitas where id = ").append(id_receita);

		mysql_query(getMysql(), query.c_str());
		MYSQL_RES *resultado = mysql_store_result(mysql);

		if (resultado == NULL) {
			cout << "Query invalida" << endl;
			return;
		} else if (mysql_affected_rows(mysql) == 0) {
			cout << "Empty set" << endl;
			return;
		}

		query.assign("select numero, titulo from receitas_etapas where receita_id = ").append(id_receita);

		if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
			cout << "\nInforme o numero da etapa:";
			getline(cin, numero_etapa);
			numero_etapa = getUtil()->testSqlInjection(getMysql(), numero_etapa);

			query.append(" and numero = ").append(numero_etapa);

			if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
				cout << endl << "[Adicionando Passo na Etapa]" << endl;

				cout << "\nInforme o a sequencia do passo:";
				string sequencia;
				getline(cin, sequencia);
				sequencia = getUtil()->testSqlInjection(getMysql(), sequencia);

				cout << "\nInforme o a instrucao do passo:";
				string instrucao;
				getline(cin, instrucao);
				instrucao = getUtil()->testSqlInjection(getMysql(), instrucao);

				query.assign("insert into receitas_passos ")
					.append(" (receita_id, etapa_numero, sequencia, instrucao) VALUES ")
					.append("(").append(id_receita).append(",")
					.append(numero_etapa).append(",")
					.append(sequencia).append(",'")
					.append(instrucao).append("')");

				if (mysql_query(getMysql(), query.c_str()) != 0)
					cout << "Ops... nao foi possivel cadastrar etapa à receita." << endl;
				else
					cout << "O passo da etapa foi cadastrada com sucesso" << endl;
			}
		}
	}
}


void ControlInsert::adicionarComentarioReceita() {
	string query = "select id, nome from receitas";

	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
		string receita_id;

		cout << "\nInforme o codigo da receita: ";
		cin.ignore();
		getline(cin, receita_id);
		receita_id = getUtil()->testSqlInjection(getMysql(), receita_id);

		query.append(" where id = ").append(receita_id);

		mysql_query(getMysql(), query.c_str());
		if (mysql_store_result(getMysql()) == NULL) {
			cout << "Query invalida" << endl;
			return;
		} else if (mysql_affected_rows(getMysql()) == 0) {
			cout << "Receita nao encontrada" << endl;
			return;
		}

		string mensagem;
		cout << "Informe a mensagem do comentario: ";
		getline(cin, mensagem);
		mensagem = getUtil()->testSqlInjection(getMysql(), mensagem);

		query.assign("insert into comentarios")
			.append("(usuario_id, receita_id, data_hora, mensagem) values (")
			.append(to_string(getUtil()->getId())).append(", ")
			.append(receita_id).append(", '")
			.append(getUtil()->getDataAtual()).append("', '")
			.append(mensagem).append("')");

		if (mysql_query(getMysql(), query.c_str()) != 0) {
			cout << "Nao foi possivel cadastrar o comentario" << endl;
			return;
		}
		cout << "comentario inserido com sucesso" << endl;
	}
}

void ControlInsert::adicionarCurtidaReceita() {
	string query = "select id, nome from receitas";

	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
		string receita_id;

		cout << "\nInforme o codigo da receita: ";
		cin.ignore();
		getline(cin, receita_id);
		receita_id = getUtil()->testSqlInjection(getMysql(), receita_id);

		query.append(" where id = ").append(receita_id);

		mysql_query(getMysql(), query.c_str());
		if (mysql_store_result(getMysql()) == NULL) {
			cout << "Query invalida" << endl;
			return;
		} else if (mysql_affected_rows(getMysql()) == 0) {
			cout << "Receita nao encontrada" << endl;
			return;
		}

		string estrelas;
		cout << "Informe a quantidade de estrelas: ";
		getline(cin, estrelas);
		estrelas = getUtil()->testSqlInjection(getMysql(), estrelas);

		query.assign("insert into curtidas")
			.append("(usuario_id, receita_id, estrelas) values (")
			.append(to_string(getUtil()->getId())).append(", ")
			.append(receita_id).append(", '")
			.append(estrelas).append("')");

		if (mysql_query(getMysql(), query.c_str()) != 0) {
			cout << "Nao foi possivel cadastrar a curtida" << endl;
			return;
		}
		cout << "Curtida inserida com sucesso" << endl;
	}
}

void ControlInsert::adicionarFotoReceita() {
	string query = "select id, nome from receitas";

	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
		string receita_id;

		cout << "\nInforme o codigo da receita: ";
		cin.ignore();
		getline(cin, receita_id);
		receita_id = getUtil()->testSqlInjection(getMysql(), receita_id);

		query.append(" where id = ").append(receita_id);

		mysql_query(getMysql(), query.c_str());
		if (mysql_store_result(getMysql()) == NULL) {
			cout << "Query invalida" << endl;
			return;
		} else if (mysql_affected_rows(getMysql()) == 0) {
			cout << "Receita nao encontrada" << endl;
			return;
		}

		string arquivoFoto;
		cout << "Informe o nome de arquivo da foto: ";
		getline(cin, arquivoFoto);
		arquivoFoto = getUtil()->testSqlInjection(getMysql(), arquivoFoto);

		query.assign("insert into receitas_fotos")
			.append("(receita_id, arquivo) values (")
			.append(receita_id).append(", '")
			.append(arquivoFoto).append("')");

		if (mysql_query(getMysql(), query.c_str()) != 0) {
			cout << "Nao foi possivel cadastrar a foto" << endl;
			return;
		}
		cout << "Foto inserida com sucesso" << endl;
	}
}

void ControlInsert::receitaExperimentar(string usuario_id) {
	string query = "select id, nome from receitas";

	if (getUtil()->imprimeDados(getMysql(), query.c_str())) {
		string receita_id;
		cout << "\nInforme o codigo da receita: ";
		cin.ignore();
		getline(cin, receita_id);
		receita_id = getUtil()->testSqlInjection(getMysql(), receita_id);

		query.assign("insert into receitas_salvas")
			.append("(usuario_id, receita_id) values (")
			.append(usuario_id).append(", ")
			.append(receita_id).append(")");

		if (mysql_query(getMysql(), query.c_str()) != 0) {
			cout << "Nao foi possivel salvar a receita" << endl;
			return;
		}
		cout << "Receita salva para ver mais tarde" << endl;
	}
}