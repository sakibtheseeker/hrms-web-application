<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminPromotion.aspx.cs"
    Inherits="Solution360.AdminPromotion" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Promotion Management</title>

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
        <h4>Promotion Management</h4>
        <button type="button" class="btn btn-primary-custom" onclick="openAddModal()">
            <i class="bi bi-plus-circle"></i> Add Promotion
        </button>
    </div>

    <!-- SEARCH -->
    <div class="card mb-3">
        <div class="card-body">
            <asp:TextBox ID="txtSearch" runat="server"
                CssClass="form-control"
                Placeholder="Search employee..."
                AutoPostBack="true"
                OnTextChanged="txtSearch_TextChanged" />
        </div>
    </div>

    <!-- TABLE -->
    <div class="card shadow-sm">
        <div class="card-body p-0">

            <asp:GridView ID="gvPromotion" runat="server"
                CssClass="table table-striped table-bordered mb-0"
                AutoGenerateColumns="false"
                AllowPaging="true"
                PageSize="10"
                OnPageIndexChanging="gvPromotion_PageIndexChanging">

                <Columns>
                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
                    <asp:BoundField DataField="DesignationFrom" HeaderText="From" />
                    <asp:BoundField DataField="DesignationTo" HeaderText="To" />
                    <asp:BoundField DataField="PromotionDate" HeaderText="Date"
                        DataFormatString="{0:dd-MMM-yyyy}" />

                   
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <button type="button"
                                class="btn btn-sm btn-outline-primary-custom me-1"
                                onclick="editPromotion('<%# Eval("PromotionId") %>')">
                                <i class="bi bi-pencil"></i>
                            </button>

                            <button type="button"
                                class="btn btn-sm btn-outline-danger"
                                onclick="deletePromotion('<%# Eval("PromotionId") %>')">
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
<div class="modal fade" id="promotionModal" tabindex="-1">
    <div class="modal-dialog modal-md">
        <div class="modal-content">

            <div class="modal-header bg-primary-custom text-white">
                <h5 class="modal-title">Promotion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <asp:HiddenField ID="hfPromotionId" runat="server" />

                <label>Employee</label>
                <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-select mb-2" />

                <label>From</label>
                <asp:DropDownList ID="ddlFrom" runat="server" CssClass="form-select mb-2" />

                <label>To</label>
                <asp:DropDownList ID="ddlTo" runat="server" CssClass="form-select mb-2" />

                <label>Date</label>
                <asp:TextBox ID="txtDate" runat="server"
                    CssClass="form-control" TextMode="Date" />

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
        $('#<%= hfPromotionId.ClientID %>').val('');
        var modal = new bootstrap.Modal(document.getElementById('promotionModal'));
        modal.show();
    }

    function editPromotion(id) {
        $.ajax({
            type: "POST",
            url: "AdminPromotion.aspx/GetPromotion",
            data: JSON.stringify({ id: id }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                var d = res.d;

                $('#<%= hfPromotionId.ClientID %>').val(d.PromotionId);
                $('#<%= ddlUser.ClientID %>').val(d.UserId);
                $('#<%= ddlFrom.ClientID %>').val(d.DesignationFrom);
                $('#<%= ddlTo.ClientID %>').val(d.DesignationTo);
                $('#<%= txtDate.ClientID %>').val(d.Date);

                var modal = new bootstrap.Modal(document.getElementById('promotionModal'));
                modal.show();
            }
        });
    }

    function deletePromotion(id) {
        if (!confirm("Delete this promotion?")) return;

        $.ajax({
            type: "POST",
            url: "AdminPromotion.aspx/DeletePromotionAjax",
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