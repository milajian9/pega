using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML;
using ClosedXML.Excel;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Web.Services;
using System.Data;
using System.Net;
using System.Configuration;
using System.Data.SqlClient;

namespace pega
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string get_excel(string c)
        {
            string mes = "success!";
            List<string> vs = c.Split(',').ToList();

            try
            {
                using (XLWorkbook wb = new XLWorkbook())//建立空白活頁簿
                {
                    var ws = wb.Worksheets.Add("工作表1");//建立工作表
                    ws.Cell("A1").Value = "Username";
                    ws.Cell("B1").Value = "Age";
                    ws.Cell("C1").Value = "image";

                    int r = 2;
                    for (int i = 0; i < vs.Count(); i++)
                    {
                        string name = vs[i].Substring(0, vs[i].IndexOf("("));
                        string age = vs[i].Substring(vs[i].IndexOf("(") + 1, vs[i].IndexOf(")") - vs[i].IndexOf("(") - 1);
                        string img = vs[i].Substring(vs[i].IndexOf(")") + 1, vs[i].Length - vs[i].IndexOf(")") - 1);

                        ws.Cell(r, 1).Value = name;
                        ws.Cell(r, 2).Value = age;
                        ws.Cell(r, 3).Value = img;
                    }

                    string fileName = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss") + ".xlsx";//檔案名稱
                    HttpResponse Response = HttpContext.Current.Response;
                    Response.Clear();
                    Response.Buffer = true;
                    Response.Charset = "";
                    Response.AddHeader("content-disposition", "attachment;filename=" + fileName);//跳出視窗，讓用戶端選擇要儲存的地方
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    using (MemoryStream MyMemoryStream = new MemoryStream())
                    {
                        wb.SaveAs(MyMemoryStream);
                        MyMemoryStream.WriteTo(Response.OutputStream);
                    }
                    Response.Flush();
                    Response.End();

                }


            }
            catch (Exception ex)
            {
                mes = ex.Message;
            }

            return mes;
        }

    }


}