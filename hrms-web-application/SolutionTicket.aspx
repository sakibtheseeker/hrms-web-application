<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="SolutionTicket.aspx.cs" Inherits="hrms_web_application.SolutionTicket" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Assigned Tickets</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">Dashboard</li>
                    <li class="breadcrumb-item active">Solve Tickets</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Assigned Tickets Grid -->
    <div class="card mb-4">
        <div class="card-header">
            <h4 class="card-title mb-0">My Assigned Tickets</h4>
        </div>
        <div class="card-body">
            <asp:GridView ID="gvAssignedTickets" runat="server"
                CssClass="table table-striped table-hover table-bordered"
                AutoGenerateColumns="False"
                OnRowCommand="gvAssignedTickets_RowCommand"
                EmptyDataText="No assigned tickets"
                GridLines="None">
                <HeaderStyle CssClass="table-light" />
                <Columns>
                    <asp:BoundField DataField="TicketId" HeaderText="Ticket ID" />
                    <asp:BoundField DataField="TicketTitle" HeaderText="Title" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemStyle CssClass="text-center" />
                        <ItemTemplate>
                            <asp:LinkButton runat="server"
                                CssClass="btn btn-sm btn-primary"
                                Text="View / Solve"
                                CommandName="ViewTicket"
                                CommandArgument='<%# Eval("TicketId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- SOLUTION MODAL -->
    <div class="modal fade" id="solutionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Ticket Solution</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:HiddenField ID="hfTicketId" runat="server" />

                    <!-- Previous Replies -->
                    <asp:Repeater ID="rptReplies" runat="server">
                        <ItemTemplate>
                            <div class="border rounded p-2 mb-2">
                                <b><%# Eval("RepliedBy") %></b>
                                <small class="text-muted">
                                    (<%# Eval("RepliedAt", "{0:dd-MMM-yyyy hh:mm tt}") %>)
                                </small>
                                <p class="mb-0"><%# Eval("ReplyMessage") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <hr />

                    <!-- Solution -->
                    <div class="mb-3">
                        <label class="form-label">Your Solution <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtSolution" runat="server"
                            CssClass="form-control"
                            TextMode="MultiLine"
                            Rows="4" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Attachment (optional)</label>
                        <asp:FileUpload ID="fuSolutionAttachment" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnSubmitSolution" runat="server"
                        Text="Submit Solution"
                        CssClass="btn btn-success"
                        OnClick="btnSubmitSolution_Click" />

                    <asp:Button ID="btnCloseTicket" runat="server"
                        Text="Close Ticket"
                        CssClass="btn btn-danger"
                        OnClick="btnCloseTicket_Click" />

                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancel
                    </button>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
