<%@ Page Title="Event Types" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AddMasterEvent.aspx.cs" Inherits="hrms_web_application.AddMasterEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Page Header -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Events</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">Event</li>
                    <li class="breadcrumb-item active" aria-current="page">Events List</li>
                </ol>
            </nav>
        </div>
    </div>
    <!-- /Page Header -->

    <!-- Success/Error Message -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3" role="alert">
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>
    <!-- /Success/Error Message -->

    <div class="row">
        
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title mb-0">Add Event Type</h4>
                </div>
                <div class="card-body">
                    
                    <asp:HiddenField ID="hfEventTypeId" runat="server" Value="0" />
                    
                    <!-- Event Type Name -->
                    <div class="mb-3">
                        <label class="form-label">Event Type Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEventTypeName" runat="server" 
                            CssClass="form-control" 
                            placeholder="Enter event type name"
                            MaxLength="50"></asp:TextBox>
                    </div>

                    <!-- Color Picker -->
                    <div class="mb-3">
                        <label class="form-label">Color <span class="text-danger">*</span></label>
                        <div class="d-flex align-items-center">
                            <asp:TextBox ID="txtColor" runat="server" 
                                CssClass="form-control me-2" 
                                placeholder="#563d7c"
                                MaxLength="7"
                                Style="width: 120px;"></asp:TextBox>
                            <input type="color" id="colorPicker" class="form-control form-control-color" 
                                   value="#563d7c" title="Choose color" style="width: 60px; height: 38px;">
                        </div>
                        <small class="text-muted">Choose a color for this event type</small>
                    </div>

                    <!-- Buttons -->
                    <div class="mb-3">
                        <asp:Button ID="btnAddEventType" runat="server" 
                            Text="Add Event Type" 
                            CssClass="btn btn-primary"
                            OnClick="btnAddEventType_Click" />
                        <asp:Button ID="btnCancel" runat="server" 
                            Text="Cancel" 
                            CssClass="btn btn-light ms-2"
                            OnClick="btnCancel_Click"
                            CausesValidation="false"
                            Visible="false" />
                    </div>

                </div>
            </div>
        </div>
        <!-- /Left Section -->

        <!-- Right Section - Existing Event Types -->
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title mb-0">Existing Event Types</h4>
                </div>
                <div class="card-body">
                    
                    <!-- GridView for Event Types -->
                    <div class="table-responsive">
                        <asp:GridView ID="gvEventTypes" runat="server" 
                            CssClass="table table-striped table-hover"
                            AutoGenerateColumns="False"
                            DataKeyNames="Id"
                            OnRowCommand="gvEventTypes_RowCommand"
                            OnRowDataBound="gvEventTypes_RowDataBound"
                            EmptyDataText="No event types found">
                            <Columns>
                                
                                <asp:BoundField DataField="Name" HeaderText="Name" 
                                    HeaderStyle-CssClass="fw-bold" 
                                    ItemStyle-CssClass="align-middle" />
                                
                                <asp:BoundField DataField="Color" HeaderText="Color" 
                                    HeaderStyle-CssClass="fw-bold" 
                                    ItemStyle-CssClass="align-middle" />
                                
                                <asp:TemplateField HeaderText="Sample">
                                    <HeaderStyle CssClass="fw-bold" />
                                    <ItemStyle CssClass="align-middle" />
                                    <ItemTemplate>
                                        <div style='width: 40px; height: 40px; background-color: <%# Eval("Color") %>; border-radius: 4px;'></div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Action">
                                    <HeaderStyle CssClass="fw-bold text-end" />
                                    <ItemStyle CssClass="align-middle text-end" />
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" 
                                            CommandName="EditEventType" 
                                            CommandArgument='<%# Eval("Id") %>'
                                            CssClass="btn btn-sm btn-icon btn-light me-1"
                                            ToolTip="Edit"
                                            CausesValidation="false">
                                            <i class="ti ti-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" 
                                            CommandName="DeleteEventType" 
                                            CommandArgument='<%# Eval("Id") %>'
                                            CssClass="btn btn-sm btn-icon btn-danger"
                                            ToolTip="Delete"
                                            CausesValidation="false">
                                            <i class="ti ti-trash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-4 text-muted">
                                    <i class="ti ti-folder-off" style="font-size: 48px;"></i>
                                    <p class="mt-2">No event types found</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                    <!-- /GridView -->

                </div>
            </div>
        </div>
        <!-- /Right Section -->

    </div>

    <!-- Edit Event Type Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Event Type</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Hidden Field for Edit ID -->
                    <asp:HiddenField ID="hfEditEventTypeId" runat="server" Value="0" />
                    
                    <!-- Event Type Name -->
                    <div class="mb-3">
                        <label class="form-label">Event Type Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEditEventTypeName" runat="server" 
                            CssClass="form-control" 
                            placeholder="Enter event type name"
                            MaxLength="50"></asp:TextBox>
                    </div>

                    <!-- Color Picker -->
                    <div class="mb-3">
                        <label class="form-label">Color <span class="text-danger">*</span></label>
                        <div class="d-flex align-items-center">
                            <asp:TextBox ID="txtEditColor" runat="server" 
                                CssClass="form-control me-2" 
                                placeholder="#563d7c"
                                MaxLength="7"
                                Style="width: 120px;"></asp:TextBox>
                            <input type="color" id="editColorPicker" class="form-control form-control-color" 
                                   value="#563d7c" title="Choose color" style="width: 60px; height: 38px;">
                        </div>
                        <small class="text-muted">Choose a color for this event type</small>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnUpdateEventType" runat="server" 
                        Text="Update Event Type" 
                        CssClass="btn btn-primary"
                        OnClick="btnUpdateEventType_Click" />
                </div>
            </div>
        </div>
    </div>
    <!-- /Edit Event Type Modal -->

    <!-- JavaScript for Color Picker -->
    <script type="text/javascript">
        // Color picker aur text box sync karna
        document.addEventListener('DOMContentLoaded', function () {
            // Add form color picker
            var colorPicker = document.getElementById('colorPicker');
            var colorText = document.getElementById('<%= txtColor.ClientID %>');

            if (colorPicker && colorText) {
                // Color picker change hone par text box update karna
                colorPicker.addEventListener('input', function () {
                    colorText.value = colorPicker.value.toUpperCase();
                });

                // Text box change hone par color picker update karna
                colorText.addEventListener('input', function () {
                    if (colorText.value.match(/^#[0-9A-Fa-f]{6}$/)) {
                        colorPicker.value = colorText.value;
                    }
                });

                // Initial sync
                if (colorText.value && colorText.value.match(/^#[0-9A-Fa-f]{6}$/)) {
                    colorPicker.value = colorText.value;
                } else {
                    colorText.value = colorPicker.value.toUpperCase();
                }
            }

            // Edit modal color picker
            var editColorPicker = document.getElementById('editColorPicker');
            var editColorText = document.getElementById('<%= txtEditColor.ClientID %>');

            if (editColorPicker && editColorText) {
                // Color picker change hone par text box update karna
                editColorPicker.addEventListener('input', function () {
                    editColorText.value = editColorPicker.value.toUpperCase();
                });

                // Text box change hone par color picker update karna
                editColorText.addEventListener('input', function () {
                    if (editColorText.value.match(/^#[0-9A-Fa-f]{6}$/)) {
                        editColorPicker.value = editColorText.value;
                    }
                });
            }
        });

        // Edit modal open karne ka function
        function openEditModal(id, name, color) {
            document.getElementById('<%= hfEditEventTypeId.ClientID %>').value = id;
            document.getElementById('<%= txtEditEventTypeName.ClientID %>').value = name;
            document.getElementById('<%= txtEditColor.ClientID %>').value = color;
            document.getElementById('editColorPicker').value = color;

            var modal = new bootstrap.Modal(document.getElementById('editModal'));
            modal.show();
        }
    </script>

    <!-- Custom CSS -->
    <style>
        .table > tbody > tr > td {
            vertical-align: middle;
        }
        
        .btn-icon {
            width: 32px;
            height: 32px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .form-control-color {
            padding: 0;
            border: 2px solid #dee2e6;
            cursor: pointer;
        }
        
        .form-control-color:hover {
            border-color: #adb5bd;
        }
    </style>

</asp:Content>