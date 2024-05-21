using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

public class Dao
{

    private readonly string stringConexao = "Server=LOG-DAILTON\\SQLEXPRESS01; DataBase=dbTreinamento; User Id=dailton; Password=Log@123;";

    public void ExecutarProcedure(string procedure, Dictionary<string, object> parametros)
    {

        SqlConnection conn = new SqlConnection(stringConexao);

        conn.Open();

        SqlCommand cmmd = NomeCmmd(procedure, conn);

        AdicionarParametros(cmmd, parametros);

        cmmd.ExecuteNonQuery();

        cmmd.Dispose();

        conn.Close();
        conn.Dispose();
    }

    private SqlCommand NomeCmmd(string procedure, SqlConnection conn)
    {
        return new SqlCommand(procedure, conn)
        {
            CommandType = System.Data.CommandType.StoredProcedure,
            CommandTimeout = 60
        };
    }

    public List<T> ExecutarProcedureList<T>(string procedure, Dictionary<string, object> parametros)
    {
        SqlConnection conn = new SqlConnection(stringConexao);

        conn.Open();

        SqlCommand cmmd = NomeCmmd(procedure, conn);

        AdicionarParametros(cmmd, parametros);

        SqlDataReader dr = cmmd.ExecuteReader();

        List<T> list = CriaLista<T>(dr);
        cmmd.Dispose();

        conn.Close();
        conn.Dispose();


        return list;

    }

    public T ExecutarProcedure<T>(string procedure, Dictionary<string, object> parametros)
    {
        return ExecutarProcedureList<T>(procedure, parametros).FirstOrDefault();
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

    private List<T> CriaLista<T>(SqlDataReader dr)
    {
        List<T> list = null;

        if (dr.HasRows)
        {
            list = new List<T>();

            while (dr.Read())
            {
                var item = Activator.CreateInstance<T>();

                foreach (var property in typeof(T).GetProperties())
                {
                    string nomecoluna;

                    //if (property.GetCustomAttributes<ColumnAttribute>() != null)
                    //{
                    //    nomecoluna = property.GetCustomAttribute<ColumnAttribute>().Name;
                    //}
                    //else
                    //{
                    nomecoluna = property.Name;
                    //}

                    int i = GetColumnOrdinal(dr, nomecoluna);

                    if (i < 0) continue;

                    if (dr[nomecoluna] == DBNull.Value) continue;

                    if (property.PropertyType.IsEnum)
                    {
                        property.SetValue(item, Enum.Parse(property.PropertyType, dr[nomecoluna].ToString()));
                    }
                    else
                    {
                        Type converteTo = Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType;
                        property.SetValue(item, Convert.ChangeType(dr[nomecoluna], converteTo));

                    }
                }

                list.Add(item);
            }

        }

        return list;
    }
   
    private int GetColumnOrdinal(SqlDataReader dr, string columnName)
    {
        int ordinal = -1;

        for (int i = 0; i < dr.FieldCount; i++)
        {

            if (string.Equals(dr.GetName(i), columnName, StringComparison.OrdinalIgnoreCase))
            {
                ordinal = i;
                break;
            }

        }

        return ordinal;

    }
}

