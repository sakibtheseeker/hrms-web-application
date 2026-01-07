<%@ Page Title="Event List" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="EventList.aspx.cs" Inherits="hrms_web_application.EventList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Events</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">Event</li>
                    <li class="breadcrumb-item active">Events List</li>
                </ol>
            </nav>
        </div>
        <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
            <div class="mb-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#eventModal" onclick="clearEventForm();">
                    <i class="ti ti-circle-plus me-2"></i>Add Event
                </button>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </asp:Panel>

    <div class="card">
        <div class="card-header d-flex align-items-center justify-content-between flex-wrap pb-0">
            <h4 class="mb-3">Events Details</h4>
        </div>
        <div class="card-body">
            
            <div class="table-responsive">
                <div class="dataTables_wrapper dt-bootstrap5 no-footer">
                    
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <div class="dataTables_length">
                                <label class="d-flex align-items-center">
                                    Show 
                                    <asp:DropDownList ID="ddlPageSize" runat="server" 
                                        CssClass="form-select form-select-sm ms-2 me-2" 
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="5">5</asp:ListItem>
                                        <asp:ListItem Value="10" Selected="True">10</asp:ListItem>
                                        <asp:ListItem Value="25">25</asp:ListItem>
                                        <asp:ListItem Value="50">50</asp:ListItem>
                                    </asp:DropDownList>
                                    entries
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <div class="dataTables_filter">
                                <label class="d-flex align-items-center justify-content-end">
                                    Search:
                                    <asp:TextBox ID="txtSearch" runat="server" 
                                        CssClass="form-control form-control-sm ms-2" 
                                        placeholder="Search..."
                                        AutoPostBack="true"
                                        OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-sm-12">
                            <asp:GridView ID="gvEvents" runat="server" 
                                CssClass="table table-striped table-hover" 
                                AutoGenerateColumns="False"
                                DataKeyNames="Id"
                                AllowPaging="True"
                                PageSize="10"
                                OnPageIndexChanging="gvEvents_PageIndexChanging"
                                OnRowCommand="gvEvents_RowCommand"
                                OnRowDataBound="gvEvents_RowDataBound"
                                EmptyDataText="No events found">
                                
                                <Columns>
                                    
                                    <asp:BoundField DataField="Id" HeaderText="ID" 
                                        ItemStyle-CssClass="text-center" 
                                        HeaderStyle-CssClass="text-center" />
                                    
                                    <asp:BoundField DataField="Title" HeaderText="Title" />
                                    
                                    <asp:BoundField DataField="Date" HeaderText="Date" 
                                        DataFormatString="{0:yyyy-MM-dd}" />
                                    
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='badge <%# Eval("Status").ToString() == "Active" ? "badge-soft-success" : "badge-soft-danger" %>'>
                                                <i class="ti ti-point-filled me-1"></i>
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Action">
                                        <HeaderStyle CssClass="text-end" />
                                        <ItemStyle CssClass="text-end" />
                                        <ItemTemplate>
                                            <div class="action-icon d-inline-flex">
                                                <asp:LinkButton ID="btnEdit" runat="server" 
                                                    CommandName="EditEvent" 
                                                    CommandArgument='<%# Eval("Id") %>'
                                                    CssClass="me-2"
                                                    ToolTip="Edit"
                                                    CausesValidation="false">
                                                    <i class="ti ti-edit"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" 
                                                    CommandName="DeleteEvent" 
                                                    CommandArgument='<%# Eval("Id") %>'
                                                    ToolTip="Delete"
                                                    CausesValidation="false"
                                                    OnClientClick="return confirm('Are you sure you want to delete this event?');">
                                                    <i class="ti ti-trash"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                </Columns>
                                
                                <PagerStyle CssClass="d-none" />
                                
                                <EmptyDataTemplate>
                                    <div class="text-center py-5">
                                        <i class="ti ti-folder-off" style="font-size: 48px; color: #ccc;"></i>
                                        <p class="text-muted mt-2">No events found</p>
                                    </div>
                                </EmptyDataTemplate>
                                
                            </asp:GridView>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-sm-12 col-md-5">
                            <div class="dataTables_info">
                                <asp:Label ID="lblInfo" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-7">
                            <div class="dataTables_paginate paging_simple_numbers">
                                <ul class="pagination justify-content-end mb-0">
                                    <li class="paginate_button page-item previous">
                                        <asp:LinkButton ID="btnPrevious" runat="server" 
                                            CssClass="page-link" 
                                            OnClick="btnPrevious_Click"
                                            CausesValidation="false">
                                            Previous
                                        </asp:LinkButton>
                                    </li>
                                    <li class="paginate_button page-item active">
                                        <asp:Label ID="lblCurrentPage" runat="server" CssClass="page-link"></asp:Label>
                                    </li>
                                    <li class="paginate_button page-item next">
                                        <asp:LinkButton ID="btnNext" runat="server" 
                                            CssClass="page-link" 
                                            OnClick="btnNext_Click"
                                            CausesValidation="false">
                                            Next
                                        </asp:LinkButton>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>

    <!-- UPDATED MODAL - Status Dropdown and Validation Messages Removed -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <asp:Label ID="lblModalTitle" runat="server" Text="Add Event"></asp:Label>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    
                    <asp:HiddenField ID="hfEventId" runat="server" Value="0" />
                    
                    <div class="mb-3">
                        <label class="form-label">Event Title <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" 
                            placeholder="Enter event title" MaxLength="200"></asp:TextBox>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Event Date <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" 
                            TextMode="Date"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Event Type <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlEventType" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEvent" runat="server" Text="Save Event" 
                        CssClass="btn btn-primary" 
                        OnClick="btnSaveEvent_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .badge-soft-success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .badge-soft-danger {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .action-icon a {
            font-size: 18px;
            color: #6c757d;
            transition: color 0.3s;
        }
        
        .action-icon a:hover {
            color: #007bff;
        }
        
        .table > tbody > tr > td {
            vertical-align: middle;
        }
        
        .paginate_button.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>

    <script type="text/javascript">
        function clearEventForm() {
            document.getElementById('<%= txtTitle.ClientID %>').value = '';
            document.getElementById('<%= txtDate.ClientID %>').value = '';
            document.getElementById('<%= ddlEventType.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= hfEventId.ClientID %>').value = '0';
            document.getElementById('<%= lblModalTitle.ClientID %>').innerText = 'Add Event';
        }

        function openEditModal(id, title, date, eventTypeId) {
            document.getElementById('<%= hfEventId.ClientID %>').value = id;
            document.getElementById('<%= txtTitle.ClientID %>').value = title;
            document.getElementById('<%= txtDate.ClientID %>').value = date;
            document.getElementById('<%= ddlEventType.ClientID %>').value = eventTypeId;
            document.getElementById('<%= lblModalTitle.ClientID %>').innerText = 'Edit Event';

            var modal = new bootstrap.Modal(document.getElementById('eventModal'));
            modal.show();
        }
    </script>

</asp:Content>