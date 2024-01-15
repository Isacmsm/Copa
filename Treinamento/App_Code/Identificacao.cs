using System.EnterpriseServices;
using System.Web;

public class Identificacao
{
    private string _IdOperador;
    private string _Sistema;
    private string _Modulo;
    private string _Pagina;

    public Identificacao() 
    {
        _IdOperador = GetIdOperador();
        string[] codigos = HttpContext.Current.Request.FilePath.Split('/');

        int count = codigos.Length;
        if (count -3 >= 0)
        {
            _Sistema = codigos[count - 3];
        }
        if  (count -2 >= 0)
        {
            _Modulo = codigos[count - 2];
        }

        if (count -1 >= 0)
        {
            _Pagina = codigos[count - 1].Split('.')[0];
        }

    }

    public string GetIdOperador()
    {
        string idOperador = null;

        if (HttpContext.Current.Session["IdOperador"] != null)
        {
            idOperador = HttpContext.Current.Session["IdOperador"].ToString();
        }

        return idOperador;

    }
    public string IdOperador
    {
        get { return _IdOperador; }
    }

    public string Sistema
    {
        get { return _Sistema; }
    }

    public string Modulo
    {
        get { return _Modulo; }
    }

    public string Pagina
    {
        get { return _Pagina; }
    }
}