using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Helpers;

public class ErroExecucaoException: Exception
{
    public List<dynamic> Erros;
    
    public ErroExecucaoException(List<SqlError> errors)
    {
        Erros = new List<dynamic>();
        
        foreach (SqlError item in errors)
        {

            // 3609 = The transation ended in the trigger. The batch has been aborted
            if (item.Number == 3609) return;

            // O erro 50001 já vem no formato json, só precisa retonar
            if (item.Number == 50001)
            {
                /*
                 * deserializar de json para objeto
                 * Formato do objeto
                 * {
                 *      NomeInput: <NOme do input, ou null em caso de mensagem de validação>
                 *      Mensagem: <Mensagem>
                 * }
                 */
                dynamic erro = Json.Decode(item.Message);

                // adiciona o objeto na lista
                Erros.Add(erro);

            }
            else
            {
                throw new Exception(item.Message);
            }
        }
    }
}