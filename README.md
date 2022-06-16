<h1>learning database using MYSQL</h1>

O MySQL é um sistema gerenciador de banco de dados relacional de código aberto usado na maioria das aplicações gratuitas para gerir suas bases de dados. O serviço utiliza a linguagem SQL (Structure Query Language – Linguagem de Consulta Estruturada), que é a linguagem mais popular para inserir, acessar e gerenciar o conteúdo armazenado num banco de dados.

<p align = "center">
    <img src="https://www.iped.com.br/img/cursos/56207.jpg" alt="MYSQL-server" width="700"></img>
</p>

Na criação de aplicações web abertas e gratuitas, o conjunto de aplicações mais usado é o LAMP, um acrônimo para Linux, Apache, MySQL e Perl/PHP/Python. Nesse conjunto de aplicações, inclui-se, respectivamente, um sistema operacional, um servidor web, um sistema gerenciador de banco de dados e uma linguagem de programação. Assim, o MySQL é um dos componentes centrais da maioria das aplicações públicas da Internet.

O sistema foi desenvolvido pela empresa sueca MySQL AB e publicado, originalmente, em maio de 1995. Após, a empresa foi comprada pela Sun Microsystems e, em janeiro de 2010, integrou a transação bilionária da compra da Sun pela Oracle Corporation. Atualmente, a Oracle, embora tenha mantido a versão para a comunidade, tornou seu uso mais restrito e os desenvolvedores criaram, então, o projeto MariaDB para continuar desenvolvendo o código da versão 5.1 do MySQL, de forma totalmente aberta e gratuita. O MariaDB pretende manter compatibilidade com as versões lançadas pela Oracle.

<h3>Instalação</h3>

Para instalar no Ubuntu:
~~~
sudo apt install mysql-server
~~~

<h2>Como usar o MySQL</h2>

Para utilizar o MySQL, é necessário instalar um servidor e uma aplicação cliente. O servidor é o responsável por armazenar os dados, responder às requisições, controlar a consistência dos dados, bem como a execução de transações concomitantes entre outras. O cliente se comunica com o servidor através da SQL.

<h3>Comandos de configuração</h3>

Para entrar no mysql como super usuário:
~~~
sudo mysql
~~~
ou
~~~
mysql -u root -p
~~~

Cria um novo usuário e define sua senha. Obsevação: A senha deve conter caracteres maiúsculos e minusculos além de caracteres especiais:

~~~
CREATE USER 'sammy'@'localhost' IDENTIFIED BY 'password';
~~~

Para conceder privilégios ao usuário:

~~~
GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;
~~~








