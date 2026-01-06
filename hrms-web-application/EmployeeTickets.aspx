<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeTickets.aspx.cs" Inherits="hrms_web_application.EmployeeTickets" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Raise Ticket -->
    <div class="card mb-4">
        <div class="card-header"><h4>Raise Ticket</h4></div>
        <div class="card-body">

            <div class="mb-3">
                <label>Ticket Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label>Attachment</label>
                <asp:FileUpload ID="fuAttachment" runat="server" CssClass="form-control" />
            </div>

            <asp:Button ID="btnRaiseTicket" runat="server"
                Text="Raise Ticket"
                CssClass="btn btn-primary"
                OnClick="btnRaiseTicket_Click" />
        </div>
    </div>

    <!-- My Tickets -->
    <div class="card">
        <div class="card-header"><h4>My Tickets</h4></div>
        <div class="card-body">

            <asp:GridView ID="gvTickets" runat="server"
                CssClass="table table-bordered"
                AutoGenerateColumns="False"
                OnRowCommand="gvTickets_RowCommand">

                <Columns>
                    <asp:BoundField DataField="TicketId" HeaderText="Ticket ID" />
                    <asp:BoundField DataField="TicketTitle" HeaderText="Title" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                    <asp:BoundField DataField="CreatedAt" HeaderText="Created On"
                        DataFormatString="{0:dd-MMM-yyyy}" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton runat="server"
                                Text="View"
                                CommandName="ViewTicket"
                                CommandArgument='<%# Eval("TicketId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

            </asp:GridView>
        </div>
    </div>

    <!-- VIEW MODAL -->
    <div class="modal fade" id="ticketModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Ticket Solution</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:Repeater ID="rptReplies" runat="server">
                        <ItemTemplate>
                            <div class="border p-2 mb-2">
                                <b><%# Eval("RepliedBy") %></b>
                                <small class="text-muted">
                                    (<%# Eval("RepliedAt","{0:dd-MMM-yyyy hh:mm tt}") %>)
                                </small>
                                <p><%# Eval("ReplyMessage") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </div>
        </div>
    </div>

</asp:Content>