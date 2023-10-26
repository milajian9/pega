<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="pega.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.bundle.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery-3.7.1.min.js"></script>
    <script>

        $(document).ready(function () {

            //open modal
            $("#btnAdd").click(function () {
                $('#modalAdd').modal('show');
            });

            //檢查表單欄位輸入是否正確
            $('.form-control').on('blur', function () {

                if (reg_test(this.id, $(this).val())) {
                    $(this).prop('class', 'form-control is-valid');//正確
                } else {
                    $(this).prop('class', 'form-control is-invalid');//不正確
                }

            });

            //上傳圖片後的顯示預覽
            $('#cfile').change(function () {
                var file = $('#cfile')[0].files[0];
                var reader = new FileReader;
                reader.onload = function (e) {
                    $('#img_preview').prop({ 'src':e.target.result, 'style':'width:5rem;'});//新增圖片的路徑與修改樣式
                };
                reader.readAsDataURL(file);
            });

            //modal's submit
            $("#modalBtnAdd").click(function () {
                var b = true;
                var name, age;

                //逐一檢查表單是否有不符合格式規定
                $('#modalDiv input[type=text]').each(function () {
                    if (!reg_test(this.id, $(this).val() )) {
                        b = false;
                        $(this).prop('class', 'form-control is-invalid');
                    }
                });

                //完全符合規定，回寫至主頁
                if (b) {
                    name = $('#txtName').val().toLowerCase();//使用者名稱轉小寫
                    name = name.replace(/^./, name[0].toUpperCase());//使用者字首轉大寫
                    age = parseInt($('#txtAge').val());//年紀轉成int

                    var mod = '<div class="card mb-1" style="width:15rem;" ><div class="card-body" style="margin:auto;">';
                    mod += '<p class="card-title" >' + name + '(' + age + 'years old)' + '</p>';
                    if ($('#img_preview').attr("src") != '#') {
                        mod += '<img class="card-img-top" src="' + $('#img_preview').prop("src") + '" style="width:5rem;"  />';
                    }
                    mod += '<input type="hidden" value="' + name + '(' + age + ')' + $('#img_preview').attr("src") + '" />';
                    mod += '</div></div>';

                    //逐一將欄位的樣式改回正常
                    $('#modalDiv input[type=text]').each(function () {
                        $(this).prop('class', 'form-control');
                        $(this).val('');
                    });

                    $('#cfile').val('');//清空上傳檔案欄位
                    $('#img_preview').prop({ 'src':'#', 'style':'display:none;'});//隱藏圖片欄位並清空路徑
                    $('#modalAdd').modal('hide');//hide modal

                    $("#divData").append(mod);//回寫主頁

                }

            });

            //下載excel
            $("#btnExcel").click(function () {
                var arr=[];
                $('#divData input[type=hidden]').each(function () {
                    arr.push($(this).val());
                });
                //console.log(JSON.stringify(arr));
                if (arr.length > 0) {
                    $.ajax({
                        async: false,
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "WebForm1.aspx/get_excel",
                        dataType: "json",
                        data: JSON.stringify({ 'c': arr.toString() }),
                        success: function () {
                            alert('下載成功!');
                        },
                        error: function () {
                            alert('下載失敗，請與系統管理員確認!');
                        }
                    });

                } else {alert('請先新增資料!');}

            });


        });

        //正則式檢查
        function reg_test(name, value) {
            var f;
            switch (name) {//檢查使用者名稱
                case 'txtName':
                    f = /^[a-zA-Z]{3,8}$/;//字串長度3-8、限制於大寫或小寫的a-z
                    return f.test(value);
                    break;

                case 'txtAge'://檢查年紀
                    f = /^[0-9]{1,3}$/;//字串長度1-3，限制數字
                    return f.test(value);
                    break;

                default:
                    return false;
                    break;
            }
            
        }

    </script>

    <style>
        body{ font-family: Arial, Helvetica Neue, Helvetica, sans-serif,"微軟正黑體"; }

    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%;padding:1rem;">
            <div class="btn-group" role="group" >
                <input type="button" id="btnAdd" value="Add" class="btn btn-primary" />
                <input type="button" id="btnExcel" value="download excel" class="btn btn-success" />
            </div>
            <div style="width:30rem;padding-top:1rem;" id="divData" >
                <%--<div class="row-3" ></div>--%>
            </div>
        </div>

        <%-- modal-start --%>
        <div id="modalAdd" class="modal fade" aria-hidden="true" >
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-body">
                        <div id="modalDiv" style="width:100%;padding:1rem;" >
                            <div class="mb-3">
                                <label for="txtName" class="form-label">Username</label>
                                <input type="text" class="form-control" id="txtName" placeholder="請輸入使用者名稱" required="required" />
                                <label for="txtName" class="invalid-feedback">請輸入3個字以上英文字母A-Z</label>
                            </div>
                            <div class="mb-3">
                                <label for="txtAge" class="form-label">Age(Years)</label>
                                <input type="text" class="form-control" id="txtAge" placeholder="請輸入年齡" required="required"  />
                                <label for="txtAge" class="invalid-feedback">請輸入數字</label>
                            </div>
                            <div class="mb-3">
                                <input type="file" class="form-control-file" accept=".jpg, .png" id="cfile" />
                                <label for="cfile" class="form-text text-muted">請上傳圖片(格式限制: jpg、png)</label>
                                
                            </div>
                            <div class="mb-3">
                                <img id="img_preview" src="#" style="display:none;" />
                            </div>
                          </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn btn-primary" id="modalBtnAdd" value="Add User" />
                    </div>
                </div>
            </div>
        </div>
        <%-- modal-end --%>

    </form>
</body>
</html>
