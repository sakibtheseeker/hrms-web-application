<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminResignation.aspx.cs"
    Inherits="Solution360.AdminResignation" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Resignation Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />
    
    <style>
        .btn-primary-custom {
            background-color: #ff6633;
            border-color: #ff6633;
            color: white;
        }
        .btn-primary-custom:hover {
            background-color: #ff5522;
            border-color: #ff5522;
            color: white;
        }
        .bg-primary-custom {
            background-color: #ff6633 !important;
        }
        .btn-outline-primary-custom {
            color: #ff6633;
            border-color: #ff6633;
        }
        .btn-outline-primary-custom:hover {
            background-color: #ff6633;
            border-color: #ff6633;
            color: white;
        }
        .btn-success-custom {
            background-color: #ff6633;
            border-color: #ff6633;
            color: white;
        }
        .btn-success-custom:hover {
            background-color: #ff5522;
            border-color: #ff5522;
            color: white;
        }
    </style>
</head>

<body class="bg-light">

<form runat="server">
    <asp:ScriptManager runat="server" />

<div class="container-fluid p-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Resignation Management</h4>
        <button type="button" class="btn btn-primary-custom" onclick="openAddModal()">
            <i class="bi bi-plus-circle"></i> Add Resignation
        </button>
    </div>

    <!-- TABLE -->
    <div class="card shadow-sm">
        <div class="card-body p-0">

            <asp:GridView ID="gvResignation" runat="server"
                CssClass="table table-striped table-bordered mb-0"
                AutoGenerateColumns="false"
                AllowPaging="true"
                PageSize="10"
                OnPageIndexChanging="gvResignation_PageIndexChanging">

                <Columns>
                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
                    <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                    <asp:BoundField DataField="NoticeDate" HeaderText="Notice Date"
                        DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:BoundField DataField="ResignDate" HeaderText="Resign Date"
                        DataFormatString="{0:dd-MMM-yyyy}" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <button type="button"
                                class="btn btn-sm btn-outline-primary-custom me-1"
                                onclick="editResignation('<%# Eval("ResignationId") %>')">
                                <i class="bi bi-pencil"></i>
                            </button>

                            <button type="button"
                                class="btn btn-sm btn-outline-danger"
                                onclick="deleteResignation('<%# Eval("ResignationId") %>')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

            </asp:GridView>

        </div>
    </div>

</div>

<!-- MODAL -->
<div class="modal fade" id="resignationModal" tabindex="-1">
    <div class="modal-dialog modal-md">
        <div class="modal-content">

            <div class="modal-header bg-primary-custom text-white">
                <h5 class="modal-title">Resignation</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <asp:HiddenField ID="hfResignationId" runat="server" />

                <label>Employee</label>
                <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-select mb-2" />

                <label>Notice Date</label>
                <asp:TextBox ID="txtNoticeDate" runat="server"
                    CssClass="form-control mb-2" TextMode="Date" />

                <label>Resignation Date</label>
                <asp:TextBox ID="txtResignDate" runat="server"
                    CssClass="form-control mb-2" TextMode="Date" />

                <label>Reason</label>
                <asp:TextBox ID="txtReason" runat="server"
                    CssClass="form-control" TextMode="MultiLine" Rows="3" />

            </div>

            <div class="modal-footer">
                <asp:Button ID="btnSave" runat="server"
                    Text="Save"
                    CssClass="btn btn-success-custom"
                    OnClick="btnSave_Click" />
            </div>

        </div>
    </div>
</div>

</form>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function openAddModal() {
        $('#<%= hfResignationId.ClientID %>').val('');
        var modal = new bootstrap.Modal(document.getElementById('resignationModal'));
        modal.show();
    }

    function editResignation(id) {
        $.ajax({
            type: "POST",
            url: "AdminResignation.aspx/GetResignation",
            data: JSON.stringify({ id: id }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                var d = res.d;

                $('#<%= hfResignationId.ClientID %>').val(d.ResignationId);
                $('#<%= ddlUser.ClientID %>').val(d.UserId);
                $('#<%= txtNoticeDate.ClientID %>').val(d.NoticeDate);
                $('#<%= txtResignDate.ClientID %>').val(d.ResignDate);
                $('#<%= txtReason.ClientID %>').val(d.Reason);

                var modal = new bootstrap.Modal(document.getElementById('resignationModal'));
                modal.show();
            }
        });
    }

    function deleteResignation(id) {
        if (!confirm("Delete this resignation?")) return;

        $.ajax({
            type: "POST",
            url: "AdminResignation.aspx/DeleteResignationAjax",
            data: JSON.stringify({ id: id }),
            contentType: "application/json; charset=utf-8",
            success: function () {
                location.reload();
            }
        });
    }
</script>

</body>
</html>