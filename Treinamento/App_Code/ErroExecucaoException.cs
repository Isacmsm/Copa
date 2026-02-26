using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Helpers;

public class ErroExecucaoException : Exception
{
    public List<dynamic> Erros;

    public ErroExecucaoException(List<SqlError> erros)
    {
        Erros = new List<dynamic>();
        foreach (SqlError item in erros)
        {
            if (item.Number == 3600) return;

            if (item.Number == 50001)
            {
                /*
                 * decodifica de json para objeto
                 * Formato do objeto
                 * {
                 *     NomeInput: <Nome do input, ou null em caso de mensagem de validação>
                 *     Mensagem: <Mensagem>
                 * }
                 */
                dynamic erro = Json.Decode(item.Message);

                //adiciona o objeto na lista
                Erros.Add(erro);
            }
            else
            {
                throw new Exception(item.Message);
            }
        }
    }
}