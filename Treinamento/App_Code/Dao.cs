using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using static DotNetOpenAuth.OpenId.Extensions.AttributeExchange.WellKnownAttributes;

public class Dao
{
    private class Autorizacao
    {
        public string NomeProcedure { get; set; }
    }

    private readonly string stringConexao = "Server=LOG-ISAC; Database=dbTreinamento; Trusted_Connection = True;"; 

    public void ExecutarProcedure(string procedure, Dictionary<string, object> parametros)
    {
        List<SqlError> erros = null;

        SqlConnection conn = new SqlConnection(stringConexao); //definindo o caminho que a ponte deve decorrer e onde ela vai levar

        conn.Open(); // abrindo a conexão (abrindo a ponte)

        SqlCommand cmmd = NovoCmmd(procedure, conn); //definindo o tipo da conexão, ou seja o meio de trasporte que vai passar pela ponte pelo metodo NovoCmmd.
                                                     //aqui foi escolhido a procedure como meio de transporte

        AdicionarParametros(cmmd, parametros); // vai adicionar os parametros ao que devem ser enviados junto com o meio de transporte (a procedure)

        //seta a configuração para disparar um evento, quando acontecer um erro de baixa relevancia na procedure
        conn.FireInfoMessageEventOnUserErrors = true;
        //função lambda para tratar cada erro disparado pela procedure 
        conn.InfoMessage += new SqlInfoMessageEventHandler((object sender, SqlInfoMessageEventArgs e) =>
        {
            //se a lista não estiver instanciada 
            if (erros == null)
            {
                //instancia uma nova lista
                erros = new List<SqlError>();
            }

            foreach (SqlError error in e.Errors)
            {
                //adiciona um erro na lista
                erros.Add(error);
            }
        });

        cmmd.ExecuteNonQuery(); // esta mandando o banco processar as informações recebidas sem esperar um retorno apenas espera

        //verifica se aconteceu algum erro
        if (erros != null)
        {
            // se aconteceu algum erro vamos disparar uma exeção personalizada
            throw new ErroExecucaoException(erros);
        }

        cmmd.Dispose(); //liberação de memoria

        conn.Close(); //fechando conexao 
        conn.Dispose(); //liberação de memoria
    }

    private SqlCommand NovoCmmd(string procedure, SqlConnection conn)
    {
        return new SqlCommand(procedure, conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure,
            CommandTimeout = 60
        };
    }

    private string GetNomeProcedure(string acao)
    {
        Identificacao identificacao = new Identificacao();

        Dictionary<string, object> parametros = new Dictionary<string, object>();
        parametros.Add("@TipoConsulta", "C_Acao");
        parametros.Add("@IdOperador", identificacao.IdOperador);
        parametros.Add("@CodigoSistema", identificacao.Sistema);
        parametros.Add("@CodigoModulo", identificacao.Modulo);
        parametros.Add("@CodigoPagina", identificacao.Pagina);
        parametros.Add("@CodigoAcao", acao);

        List<Autorizacao> autorizacoes = ExecutarProcedureList<Autorizacao>("stp_Ism_MontaMenu", parametros);

        if (autorizacoes == null)
        {
            throw new InvalidCastException("Operador não autorizado para executar essa ação");

        }

        return autorizacoes.FirstOrDefault().NomeProcedure;
    }

    public List<T> ExecutarAcaoList<T>(string acao, Dictionary<string, object> parametros)
    {
        string procedure = GetNomeProcedure(acao);
        return ExecutarProcedureList<T>(procedure, parametros);
    }

    public void ExecutarAcao(string acao, Dictionary<string, object> parametros)
    {
        string procedure = GetNomeProcedure(acao);
        ExecutarProcedure(procedure, parametros);
    }

    public List<T> ExecutarProcedureList<T>(string procedure, Dictionary<string, object> parametros)
    {
        List<T> list = null; //criando uma lista list coringa vazia

        SqlConnection conn = new SqlConnection(stringConexao); //definindo o caminho que a ponte deve decorrer e onde ela vai levar

        conn.Open();  // abrindo a conexão (abrindo a ponte)

        SqlCommand cmmd = NovoCmmd(procedure, conn); //definindo o tipo da conexão, ou seja o meio de trasporte que vai passar pela ponte pelo metodo NovoCmmd.
                                                     ////aqui foi escolhido a procedure como meio de transporte

        AdicionarParametros(cmmd, parametros); // vai adicionar os parametros ao que devem ser enviados junto com o meio de transporte (a procedure)

        SqlDataReader dr = cmmd.ExecuteReader(); // esta trazendo as informações do banco de volta 
        list = CriarLista<T>(dr); //usa as informações do banco de dados pra criar uma lista de objetos correspondentes as colunas do BD q foi retornado

        // fecha as informações que vinheram do banco de dado, pois elas ja foram armazenadas na variavel list
        dr.Close(); 
        // libera a memoria
        dr.Dispose();

        //liberação de memoria do objeto cmmd (objeto nao mais necessario)
        cmmd.Dispose(); 

        //fecha a conexao
        conn.Close();
        //libera memoria
        conn.Dispose();

        return list;
    }

    private void AdicionarParametros(SqlCommand cmmd, Dictionary<string, object> parametros)
    {
        if (parametros != null)
        {
            foreach (var item in parametros)
            {
                cmmd.Parameters.AddWithValue(item.Key, item.Value);
            }
        }
    }

    private List<T> CriarLista<T>(SqlDataReader dr)
    {
        List<T> list = null;

        //vai verificar se  o DB retornou algo.
        if (dr.HasRows) 
        {
            // a lista de uma classe coringa
            list = new List<T>();

            //vai ler linha por linha do retorno do DB, enquanto houver linhas para ler o loop continua
            while (dr.Read()) 
            {
                // aqui ele instancia o objeto coringa com o valor das suas propiedades nula, no caso do time ele vai instanciar um novo objeto Time com suas propiedades nulas
                var item = Activator.CreateInstance<T>();

                // o foreach vai olhar a classe T (coringa) e ver quais propiedades ele tem
                foreach (var property in typeof(T).GetProperties()) 
                {
                    string nomecoluna;

                    //caso a a propiedade tenha algum atributo personalizado
                    if (property.GetCustomAttribute<ColumnAttribute>() != null) 
                    {
                        nomecoluna = property.GetCustomAttribute<ColumnAttribute>().Name; //ele vai pegar o nome do atributo
                    }
                    else
                    {
                        // vai defini o nome da coluna do bando dizendo q ela é igual a propiedade da classe utilizada
                        nomecoluna = property.Name; 
                    }

                    // pergunta em qual indice no DB esta a coluna com o nome atribuido a variavel nomecoluna.
                    int i = GetColumnOrginal(dr, nomecoluna);

                    // se o indice for menor que 0, significa que a classe tem uma propiedade com esse nome mas o DB n retornou uma coluna com esse mesmo nome, então ele pula para proxima propiedade
                    if (i < 0) continue;

                    //se o valor dessa propiedade for nulo no banco ele nao faz nada deixando o valor da propiedade nulo mesmo, e pula para proxima propiedade.
                    if (dr[nomecoluna] ==  DBNull.Value) continue; 

                    if (property.PropertyType.IsEnum)
                    {
                        //aqui ele pega o valor do banco e joga pra propiedade do objeto correspondente
                        property.SetValue(item, Enum.Parse(property.PropertyType, dr[nomecoluna].ToString()));
                    }
                    else
                    {
                        Type convertTo = Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType;
                        //aqui ele peda o valor do banco e joga pra propiedade do objeto correspondente
                        property.SetValue(item, Convert.ChangeType(dr[nomecoluna],convertTo));
                    }
                }
                // depois do objeto ja estar com suas propiedades preenchidas com seus valores ele é adicionado a lista
                list.Add(item);
            }
        }
        return list;
    }

    private int GetColumnOrginal(SqlDataReader dr, string columName)
    {
        // começa assumindo que a coluna não existe
        int ordinal = -1;
        //dr.FieldCount vai dizer quantas colunas retornou para definir quantas vezes o loop vai rodar
        for (int i = 0; i < dr.FieldCount; i++) 
        {
            if(string.Equals(dr.GetName(i), columName, StringComparison.OrdinalIgnoreCase))
            {
                // se ele achar uma coluna no databank que é igual ao columName ele vai setar o i para o numero da coluna (indice dela)
                ordinal = i; 
                break;
            }
        }

        return ordinal;
        
    }
}

