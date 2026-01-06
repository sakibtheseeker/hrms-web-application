<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AdminAssignTickets.aspx.cs" Inherits="hrms_web_application.AdminAssignTickets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Page Header -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Assign Tickets</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html">Dashboard</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Assign Tickets</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Card -->
    <div class="card">
        <div class="card-header">
            <h4 class="card-title mb-0">Open Tickets</h4>
        </div>
        <div class="card-body">
            
            <!-- GridView WITHOUT datatable class -->
            <div class="table-responsive">
                <asp:GridView ID="gvTickets" runat="server"
                    CssClass="table table-striped table-hover table-bordered"
                    AutoGenerateColumns="False"
                    OnRowCommand="gvTickets_RowCommand"
                    EmptyDataText="No tickets available"
                    GridLines="None">
                    <HeaderStyle CssClass="table-light" />
                    <Columns>
                        <asp:BoundField DataField="TicketId" HeaderText="Ticket ID">
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="TicketTitle" HeaderText="Title">
                            <ItemStyle Width="400px" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="Status" HeaderText="Status">
                            <ItemStyle Width="120px" />
                        </asp:BoundField>
                        
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle Width="150px" CssClass="text-center" />
                            <ItemTemplate>
                                <asp:LinkButton ID="btnAssignTicket" runat="server"
                                    CssClass="btn btn-sm btn-primary"
                                    CommandName="AssignTicket"
                                    CommandArgument='<%# Eval("TicketId") %>'
                                    ToolTip="Assign this ticket">
                                    <i class="ti ti-user-plus"></i> Assign
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>

    <!-- ASSIGN MODAL -->
    <div class="modal fade" id="assignModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assign Ticket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfTicketId" runat="server" />
                    
                    <!-- Department -->
                    <div class="mb-3">
                        <label class="form-label">Department <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlDepartment" runat="server"
                            CssClass="form-select"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    
                    <!-- Designation -->
                    <div class="mb-3">
                        <label class="form-label">Designation <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlDesignation" runat="server"
                            CssClass="form-select"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlDesignation_SelectedIndexChanged">
                            <asp:ListItem Value="">-- Select Designation --</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <!-- Employee -->
                    <div class="mb-3">
                        <label class="form-label">Employee <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlEmployee" runat="server"
                            CssClass="form-select">
                            <asp:ListItem Value="">-- Select Employee --</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnAssign" runat="server"
                        Text="Assign Ticket"
                        CssClass="btn btn-primary"
                        OnClick="btnAssign_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>