using System;
using System.Web.WebPages.Html;

// Util é uma classe estatica que contem métodos que são usados frequentemente por várias páginas.
public static class Util
{
    //metodo que recebe uma string e retorna null quando a string é vazia, e retorna o valor da própia string quando é diferente de null.
    //para que ao usuario digitar um valor vazio, não seja enviado uma string vazia em vez de nulo para o bd
    public static string ChecaNulo(string str)
    {
        if (string.IsNullOrEmpty(str))
        {
            return null;
        }
        else
        {
            return str.Trim();
        }

    }

    public static void ExceptionHandler(Action action, ModelStateDictionary model)
    {
        try
        {
            action();
        }
        catch (ErroExecucaoException ex)
        {
            model.AddError("alert-warning", "Por favor, verifique o formulario!");

            foreach (dynamic item in ex.Erros)
            {
                model.AddError(item.NomeInput, item.Mensagem);
            }
        }
        catch (Exception ex)
        {
            model.AddError("alert-danger", ex.Message);
        }
    }

    public static string FormatarData(string data, int style)
    {
        if (string.IsNullOrWhiteSpace(data)) 
            return null;

        if (!DateTime.TryParse(data, out DateTime dt)) 
            return null;

        switch (style)
        {
            case 103: return dt.ToString("dd/MM/yyyy"); 
            case 108: return dt.ToString("HH:mm:ss"); 
            case 23: return dt.ToString("yyyy-MM-dd"); 
            case 200: return dt.ToString("HH:mm"); 
            default: return dt.ToString();
        }
    }
}