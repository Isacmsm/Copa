using System;
using System.Linq;
using System.Web.WebPages.Html;

public static class Util
{
    public enum TipoDado
    {
        FormatoDataBrasileira = 23,
        FormatoDataAmericada = 103,
        FormatoHora = 108
    }

    public static string ChecarNulo(string str)
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
            model.AddError("alert-warning", "Por favor, verifique o formulário");
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

    public static string IsInvalid(ModelStateDictionary model, string key)
    {
        return (!model.IsValidField(key) ? "is-invalid" : "");
    }
    public static bool isNumeric(string valor)
    {
        return valor.All(char.IsNumber);
    }
    public static string ValidaHora(string hora)
    {
        if (string.IsNullOrWhiteSpace(hora))
        {
            return null;
        }
        //verifica se existem dois caracteres :
        int qtd = hora.Split(':').Length;
        if (qtd != 2)
        {
            return null;
        }
        //verificar se existe numero de hora, minutos e segundos
        for (int i = 0; i < qtd; i++)
        {
            if (!isNumeric(hora.Split(':')[i].ToString()))
            {
                return null;
            }
        }

        //verifica se a hora é maior que 23
        if (int.Parse(hora.Split(':')[0].ToString())>23)
        {
            return null;
        }

        //verifica se os minutos ou segundos são maiores que 59
        for (int i = 1; i < qtd; i++)
        {
            if (int.Parse(hora.Split(':')[i].ToString())>59)
            {
                return null;
            }
        }

        return hora;
    }

    public static string FormatarData(string data, TipoDado tipo)
    {
        if (data == null)
        {
            return null;
        }
        string ret = "";
        if (!string.IsNullOrWhiteSpace(data))
        {
            DateTime dataAux = DateTime.Parse(data);

            switch (tipo)
            {
                case TipoDado.FormatoDataAmericada:
                    ret = dataAux.ToString("yyyy-MM-dd");
                    break;

                case TipoDado.FormatoDataBrasileira:
                    ret = dataAux.ToString("dd/MM/yyyy");
                    break;
                case TipoDado.FormatoHora:
                    ret = dataAux.ToString("HH:mm:ss");
                    break;
            }
        }
        return ret;
    }
}