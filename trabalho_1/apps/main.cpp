#include "util.hpp"
#include "control.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int menu(Util *util);
void gerenciamento(MYSQL *mysql, Util *util);

int menuGerenciamento();
int menuInsersao();
int menuImpresao();
int menuEdicao();
int menuRemocao();

int main() {

    Util *util = new Util;

    char usuario[] = "aluno";
    char senha[] = "Senh@Alun0";
    char banco[] = "cefet_receitas";
    char host[] = "127.0.0.1";

    // char *teste = (char *)malloc(sizeof(char) * 20);
    // strcpy(teste, "\"or 1=1 or ''=\"");

    // char *res = (char *)malloc(sizeof(char) * 20);

    MYSQL *mysql = mysql_init(NULL);
    // string t = "danie'l";
    // string newStr = util->testSqlInjection(mysql, t);

    // cout << t << endl;
    // cout << newStr << endl;

    // return 0;
    // mysql_real_escape_string_quote(mysql, res, teste, strlen(teste), '\'');
    // mysql_real_escape_string_quote(mysql, res, teste, strlen(teste), ' ');

    // cout << "teste: " << teste << endl;
    // cout << "res: " << res << endl;
    // mysql_real_escape_string_quote(mysql, res, teste, strlen(teste), '\'');
    // mysql_real_escape_string_quote(mysql, res, teste, strlen(teste), '\'');
    // return 0;
    if (util->conexao_banco(mysql, host, usuario, senha, banco) == EXIT_FAILURE) return EXIT_FAILURE;

    Control *control = new Control(mysql, util);

    string nomeReceita, nomeIngrediente;

    int opcao;
    do {
        if (system("clear") == -1)cout << "erro no system" << endl;
        opcao = menu(util);

        switch (opcao) {
        case 1:
            cout << "Informe o nome da receita: ";
            cin.ignore();
            getline(cin, nomeReceita);
            nomeReceita = util->testSqlInjection(mysql, nomeReceita);

            if (nomeReceita.length() > 0)
                control->getControlSelect().carregarReceitas(mysql, nomeReceita);
            else
                cout << "\nNao foi informada a receita" << endl;
            break;
        case 2:
            cout << "Informe o nome da receita: ";
            cin.ignore();
            getline(cin, nomeIngrediente);
            nomeIngrediente = util->testSqlInjection(mysql, nomeIngrediente);

            if (nomeIngrediente.length() > 0)
                control->getControlSelect().buscarReceitaPorIngrediente(nomeIngrediente);
            else
                cout << "\nNao foi informado o ingrediente" << endl;
            break;
        case 3:
            util->login(mysql);
            break;
        case 4:
            if (util->getStatus())
                gerenciamento(mysql, util);
            else
                printf("opção invalida...\n");
            break;
        case 0:
            printf("Até logo!\n\n");

            delete util;
            delete control;
            mysql_close(mysql);

            return EXIT_SUCCESS;
        default:
            printf("opção invalida...\n");
            break;
        }
        if (system("read -p \"\nPressione enter para continuar...\" continue") == -1)cout << "erro no system" << endl;
    } while (opcao != 0);

    return EXIT_SUCCESS;
}

int menu(Util *util) {
    int opcao;

    cout << "MENU " << util->getUser() << endl << endl;
    cout << "[1] Pesquisar receita por nome" << endl;
    cout << "[2] Pesquisar receita por engrediente" << endl;
    cout << "[3] " << ((util->getStatus()) ? "Logout" : "Entrar") << endl;
    if (util->getStatus()) cout << "[4] Gerenciamento" << endl;
    cout << "[0] Sair" << endl << endl;
    cout << ">>> ";

    cin >> opcao;

    return opcao;
}

void gerenciamento(MYSQL *mysql, Util *util) {
    int op;

    Control *control = new Control(mysql, util);

    do {
        if (system("clear") == -1)cout << "erro no system" << endl;
        op = menuGerenciamento();

        switch (op) {
        case 1:
            control->opcoesInsert(menuInsersao());
            break;
        case 2:
            control->opcoesSelect(menuImpresao());
            break;
        case 3:
            control->opcoesDelete(menuRemocao());
            break;
        case 4:
            control->opcoesUpdate(menuEdicao());
            break;
        case 0:
            delete control;
            return;
        default:
            cout << "Opcao invalida" << endl;
            break;
        }
        if (system("read -p \"\nPressione enter para continuar...\" continue") == -1)cout << "erro no system" << endl;
    } while (op != 0);
}

int menuGerenciamento() {
    int opcao;

    cout << "MENU GERENCIAMENTO" << endl << endl;
    cout << "[1] Cadastro" << endl;
    cout << "[2] Impressao" << endl;
    cout << "[3] Remocao" << endl;
    cout << "[4] Atualizacao" << endl;
    cout << "[0] Voltar" << endl << endl;
    cout << ">>> ";

    cin >> opcao;
    return opcao;
}

int menuInsersao() {
    if (system("clear") == -1)cout << "erro no system" << endl;
    int opcao;

    cout << "MENU INSERCAO" << endl << endl;
    cout << "[ 1] Inserir Ingrediente" << endl;
    cout << "[ 2] Inserir Usuario" << endl;
    cout << "[ 3] Inserir Receita" << endl;
    cout << "[ 4] Inserir Ingrediente da Receita" << endl;
    cout << "[ 5] Inserir Etapa" << endl;
    cout << "[ 6] Inserir Passo" << endl;
    cout << "[ 7] Inserir Comentario" << endl;
    cout << "[ 8] Inserir Curtida" << endl;
    cout << "[ 9] Inserir Foto" << endl;
    cout << "[10] Inserir Receita no usuario" << endl;
    cout << "[ 0] Voltar" << endl << endl;
    cout << ">>> ";

    cin >> opcao;
    return opcao;
}

int menuImpresao() {
    if (system("clear") == -1)cout << "erro no system" << endl;
    int opcao;

    cout << "MENU IMPRESSAO" << endl << endl;
    cout << "[1] Imprimir Ingredientes" << endl;
    cout << "[2] Imprimir Usuarios" << endl;
    cout << "[3] Imprimir Receitas" << endl;
    cout << "[4] Imprimir Comentarios" << endl;
    cout << "[5] Imprimir Curtidas" << endl;
    cout << "[6] Imprimir Fotos" << endl;
    cout << "[0] Voltar" << endl << endl;
    cout << ">>> ";

    cin >> opcao;
    return opcao;
}

int menuEdicao() {
    if (system("clear") == -1)cout << "erro no system" << endl;
    int opcao;

    cout << "MENU ATUALIZACAO" << endl << endl;
    cout << "[1] Atualizar Ingrediente" << endl;
    cout << "[2] Atualizar Usuario" << endl;
    cout << "[3] Atualizar Receita" << endl;
    cout << "[4] Atualizar Foto da Receita" << endl;
    cout << "[5] Atualizar Ingrediente da Receita" << endl;
    cout << "[6] Atualizar Etapa da Receita" << endl;
    cout << "[7] Atualizar Passos da Receita" << endl << endl;
    cout << "[0] Voltar" << endl << endl;

    cin >> opcao;
    return opcao;
}

int menuRemocao() {
    if (system("clear") == -1)cout << "erro no system" << endl;
    int opcao;

    cout << "MENU REMOCAO" << endl << endl;
    cout << "[1] Remover Ingrediente" << endl;
    cout << "[2] Remover Usuario" << endl;
    cout << "[3] Remover Receita" << endl;
    cout << "[4] Remover Ingrediente da Receita" << endl;
    cout << "[5] Remover Etapas da Receita" << endl;
    cout << "[6] Remover Passos da Receita" << endl;
    cout << "[7] Remover Receita do usuario" << endl;
    cout << "[0] Voltar" << endl << endl;
    cout << ">>> ";

    cin >> opcao;
    return opcao;
}
