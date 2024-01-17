using System.Collections.Generic;

public class Botao
{
    public string IdAcao { get; set; }
    public string Codigo { get; set; }
    public string Caption { get; set; }
}
public class BotaoDao
{
    public List<Botao> GetAll()
    {
        Identificacao identificacao = new Identificacao();
        Dictionary<string, object> parametros = new Dictionary<string, object>();
        parametros.Add("@TipoConsulta", "C_Botao");
        parametros.Add("@IdOperador", identificacao.IdOperador);
        parametros.Add("@CodigoSistema", identificacao.Sistema);
        parametros.Add("@CodigoModulo", identificacao.Modulo);
        parametros.Add("@CodigoPagina", identificacao.Pagina);

        return new Dao().ExecutarProcedureList<Botao>("stp_Das_MontaMenu", parametros);
    }
}