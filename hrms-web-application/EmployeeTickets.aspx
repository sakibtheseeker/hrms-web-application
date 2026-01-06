<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeTickets.aspx.cs" Inherits="hrms_web_application.EmployeeTickets" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <!-- ================= Raise Ticket Section ================= -->
    <div class="card mb-4">
        <div class="card-header">
            <h4>Raise Ticket</h4>
        </div>

        <div class="card-body">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label>Ticket Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                </div>

                <div class="col-md-6">
                    <label>Subject</label>
                    <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" />
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Text="IT" />
                        <asp:ListItem Text="HR" />
                        <asp:ListItem Text="Payroll" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-6">
                    <label>Priority</label>
                    <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Low" />
                        <asp:ListItem Text="Medium" />
                        <asp:ListItem Text="High" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="mb-3">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server"
                    CssClass="form-control"
                    TextMode="MultiLine"
                    Rows="4" />
            </div>

            <div class="mb-3">
                <label>Attachment</label>
                <asp:FileUpload ID="fuAttachment" runat="server" CssClass="form-control" />
            </div>

            <asp:Button ID="btnRaiseTicket" runat="server"
                Text="Raise Ticket"
                CssClass="btn btn-primary" />

        </div>
    </div>

    <!-- ================= My Raised Tickets Section ================= -->
    <div class="card">
        <div class="card-header">
            <h4>My Raised Tickets</h4>
        </div>

        <div class="card-body">

            <asp:GridView ID="gvTickets"
                runat="server"
                CssClass="table table-bordered table-striped"
                AutoGenerateColumns="False">

                <Columns>
                    <asp:BoundField DataField="TicketId" HeaderText="Ticket ID" />
                    <asp:BoundField DataField="TicketTitle" HeaderText="Title" />
                    <asp:BoundField DataField="Subject" HeaderText="Subject" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkView"
                                runat="server"
                                Text="View" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

            </asp:GridView>

        </div>
    </div>
</asp:Content>
