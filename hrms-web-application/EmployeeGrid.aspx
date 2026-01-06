<%@ Page Title="Employee Grid" Language="C#" MasterPageFile="~/EmployeeMaster.master" AutoEventWireup="true" CodeBehind="EmployeeGrid.aspx.cs" Inherits="hrms_web_application.EmployeeGrid" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">
        <!-- Breadcrumb -->
        <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
            <div class="my-auto mb-2">
                <h2 class="mb-1">Employee</h2>
                <nav>
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="EmployeeDashboard.aspx"><i class="ti ti-smart-home"></i></a>
                        </li>
                        <li class="breadcrumb-item">Employee</li>
                        <li class="breadcrumb-item active" aria-current="page">Employee Grid</li>
                    </ol>
                </nav>
            </div>
            <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
                <div class="me-2 mb-2">
                    <div class="d-flex align-items-center border bg-white rounded p-1 me-2 icon-list">
                        <a href="EmpList.aspx" class="btn btn-icon btn-sm"><i class="ti ti-list-tree"></i></a>
                        <a href="EmployeeGrid.aspx" class="btn btn-icon btn-sm active bg-primary text-white"><i class="ti ti-layout-grid"></i></a>
                    </div>
                </div>
                <div class="me-2 mb-2">
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-file-export me-1"></i>Export
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li>
    <a href="Employee.aspx?export=pdf" class="dropdown-item rounded-1">
        <i class="ti ti-file-type-pdf me-1"></i>Export as PDF
    </a>
</li>
<li>
    <a href="Employee.aspx?export=excel" class="dropdown-item rounded-1">
        <i class="ti ti-file-type-xls me-1"></i>Export as Excel
    </a>
</li>
                        </ul>
                    </div>
                </div>
                <div class="mb-2">
                    <a href="#" data-bs-toggle="modal" data-bs-target="#exampleModal" class="btn btn-primary d-flex align-items-center">
                        <i class="ti ti-circle-plus me-2"></i>Add Employee
                    </a>
                </div>
                <div class="head-icons ms-2">
                    <a href="javascript:void(0);" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="Collapse" id="collapse-header">
                        <i class="ti ti-chevrons-up"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- /Breadcrumb -->

        <!-- Stats Cards -->
        <div class="row">
            <div class="col-lg-3 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center overflow-hidden">
                            <div><span class="avatar avatar-lg bg-dark rounded-circle"><i class="ti ti-users"></i></span></div>
                            <div class="ms-2 overflow-hidden">
                                <p class="fs-12 fw-medium mb-1 text-truncate">Total Employee</p>
                                <h4><asp:Literal ID="litTotal" runat="server" /></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center overflow-hidden">
                            <div><span class="avatar avatar-lg bg-success rounded-circle"><i class="ti ti-user-share"></i></span></div>
                            <div class="ms-2 overflow-hidden">
                                <p class="fs-12 fw-medium mb-1 text-truncate">Active</p>
                                <h4><asp:Literal ID="litActive" runat="server" /></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center overflow-hidden">
                            <div><span class="avatar avatar-lg bg-danger rounded-circle"><i class="ti ti-user-pause"></i></span></div>
                            <div class="ms-2 overflow-hidden">
                                <p class="fs-12 fw-medium mb-1 text-truncate">InActive</p>
                                <h4><asp:Literal ID="litInactive" runat="server" /></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center overflow-hidden">
                            <div><span class="avatar avatar-lg bg-info rounded-circle"><i class="ti ti-user-plus"></i></span></div>
                            <div class="ms-2 overflow-hidden">
                                <p class="fs-12 fw-medium mb-1 text-truncate">New Joiners</p>
                                <h4><asp:Literal ID="litNewJoiners" runat="server" /></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between flex-wrap row-gap-3">
                <h5>Employee List</h5>
                <div class="d-flex my-xl-auto right-content align-items-center flex-wrap row-gap-3">
                    <div class="dropdown me-3">
                        <asp:DropDownList ID="ddlDesignationFilter" CssClass="form-control" runat="server">
                            <asp:ListItem Value="0" Text="Select Designation" />
                        </asp:DropDownList>
                    </div>
                    <div class="dropdown">
                        <select id="optgrid" class="form-control">
                            <option value="">Sorting By</option>
                            <option value="asc">Ascending (Name)</option>
                            <option value="desc">Descending (Name)</option>
                            <option value="productivityasc">Ascending (Productivity)</option>
                            <option value="productivitydesc">Descending (Productivity)</option>
                            <option value="last7days">Last 7 Days</option>
                            <option value="thismonth">This Month</option>
                            <option value="thisyear">This Year</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Employee Grid -->
<div class="row employee-grid-container">
    <asp:Repeater ID="rptEmployees" runat="server">
        <ItemTemplate>
            <div class="col-xl-4 col-lg-4 col-md-6 mb-4 employee-card" data-designation='<%# Eval("DesignationId") %>'>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="form-check form-check-md">
                                <input class="form-check-input" type="checkbox">
                            </div>
                            <div>
                                <a href="employee-details.html" class="avatar avatar-xl avatar-rounded online border p-1 border-primary rounded-circle">
                                    <img src='<%# String.IsNullOrEmpty(Eval("ProfilePicture").ToString()) ? ResolveUrl("~/assets/img/profiles/default-avatar.jpg") : ResolveUrl(Eval("ProfilePicture").ToString()) %>' 
                                         class="img-fluid h-auto w-auto" alt="Profile Picture">
                                </a>
                            </div>
                            <div class="dropdown"></div>
                        </div>
                        <div class="text-center mb-3">
                            <h6 class="mb-1"><%# Eval("FirstName") %> <%# Eval("LastName") %></h6>
                            <span class="mb-3"><%# Eval("DesignationName") %></span>
                        </div>
                        <div class="row text-center">
                            <div class="col-4">
                                <div class="mb-3">
                                    <span class="fs-12">Projects</span>
                                    <h6 class="fw-medium"><%# Eval("TotalProjects") %></h6>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <span class="fs-12">Done</span>
                                    <h6 class="fw-medium"><%# Eval("CompletedTasks") %></h6>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="mb-3">
                                    <span class="fs-12">Progress</span>
                                    <h6 class="fw-medium"><%# Eval("InProgressTasks") %></h6>
                                </div>
                            </div>
                        </div>
                        <p class="mb-2 text-center">Productivity: <span class="text-purple"><%# Eval("Productivity") %>%</span></p>
                        <div class="progress progress-xs mb-2">
                            <div class="progress-bar bg-purple" role="progressbar" style='width: <%# Eval("Productivity") %>%;'></div>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Manual "No Data" Message -->
    <asp:Panel ID="pnlNoData" runat="server" Visible='<%# rptEmployees.Items.Count == 0 %>'>
        <div class="col-12 text-center">
            <p>No employees found.</p>
        </div>
    </asp:Panel>
</div>
<!-- /Employee Grid -->
    </div>

    <!-- Add Employee Modal -->
    <div class="modal fade" id="exampleModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center">
                        <h4 class="modal-title me-2">Add New Employee</h4>
                    </div>
                    <button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <i class="ti ti-x"></i>
                    </button>
                </div>
                <form method="post" id="myempform" enctype="multipart/form-data">
                    <div class="contact-grids-tab">
                        <ul class="nav nav-underline" id="myTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#basic-info" type="button" role="tab" aria-selected="true">Basic Information</button>
                            </li>
                        </ul>
                    </div>
                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade show active" id="basic-info" role="tabpanel">
                            <div class="modal-body pb-0">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="d-flex align-items-center flex-wrap row-gap-3 bg-light w-100 rounded p-3 mb-4">
                                            <div class="d-flex align-items-center justify-content-center avatar avatar-xxl rounded-circle border border-dashed me-2 flex-shrink-0 text-dark frames">
                                                <i class="ti ti-photo text-gray-2 fs-16"></i>
                                            </div>
                                            <div class="profile-upload">
                                                <div class="mb-2">
                                                    <h6 class="mb-1">Upload Profile Image</h6>
                                                    <p class="fs-12">Image should be below 4 mb</p>
                                                </div>
                                                <div class="profile-uploader d-flex align-items-center">
                                                    <div class="drag-upload-btn btn btn-sm btn-primary me-2">
                                                        Upload
                                                        <input type="file" class="form-control image-sign" id="ProfilePicture" name="ProfilePicture" accept="image/*">
                                                    </div>
                                                    <a href="javascript:void(0);" class="btn btn-light btn-sm">Cancel</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                                            <input type="text" name="FirstName" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Last Name</label>
                                            <input type="text" name="LastName" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" name="Email" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Password <span class="text-danger">*</span></label>
                                            <div class="pass-group">
                                                <input type="password" name="PasswordHash" class="pass-input form-control" required>
                                                <span class="ti toggle-password ti-eye-off"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Joining Date <span class="text-danger">*</span></label>
                                            <div class="input-icon-end position-relative">
                                                <input type="text" class="form-control datetimepicker" name="DateOfJoining" placeholder="dd/mm/yyyy" required>
                                                <span class="input-icon-addon"><i class="ti ti-calendar text-gray-7"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Birth Date <span class="text-danger">*</span></label>
                                            <div class="input-icon-end position-relative">
                                                <input type="text" class="form-control datetimepicker" name="DateOfBirth" placeholder="dd/mm/yyyy" required>
                                                <span class="input-icon-addon"><i class="ti ti-calendar text-gray-7"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Role</label>
                                            <asp:DropDownList ID="ddlRoleAdd" CssClass="form-control" runat="server" ClientIDMode="Static" required="required">
                                                <asp:ListItem Value="" Text="-- Select Role --" Selected="True" Disabled="True" Hidden="True"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="departmentContainer">
                                        <div class="mb-3">
                                            <label class="form-label">Department</label>
                                            <asp:DropDownList ID="ddlDepartmentAdd" CssClass="form-control" runat="server" ClientIDMode="Static" required="required">
                                                <asp:ListItem Value="" Text="-- Select Department --" Selected="True" Disabled="True"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="managerContainer">
                                        <div class="mb-3">
                                            <label class="form-label">Manager</label>
                                            <asp:DropDownList ID="ddlManagerAdd" CssClass="form-control" runat="server" ClientIDMode="Static" Enabled="false">
                                                <asp:ListItem Value="" Text="-- Select Manager --"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="designationContainer">
                                        <div class="mb-3">
                                            <label class="form-label">Designation</label>
                                            <asp:DropDownList ID="ddlDesignationAdd" CssClass="form-control" runat="server" ClientIDMode="Static" required="required">
                                                <asp:ListItem Value="" Text="-- Select Designation --" Selected="True" Disabled="True"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                                            <input type="text" name="PhoneNumber" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Address <span class="text-danger">*</span></label>
                                            <input type="text" name="Address" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Gender</label>
                                            <select class="form-control" name="Gender" required>
                                                <option value="" disabled selected hidden>Select</option>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Status</label>
                                            <select class="form-control" name="Status" required>
                                                <option value="" disabled selected hidden>Select</option>
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label class="form-label">About <span class="text-danger">*</span></label>
                                            <textarea name="AboutEmployee" class="form-control" rows="3" required></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-light border me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" id="savebtn1">Save</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- /Add Employee Modal -->

    <!-- Edit Employee Modal -->
    <div class="modal fade" id="editModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center">
                        <h4 class="modal-title me-2">Edit Employee</h4><span>Employee ID : EMP -0024</span>
                    </div>
                    <button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal" aria-label="Close">
                        <i class="ti ti-x"></i>
                    </button>
                </div>
                <form method="post" id="editForm" enctype="multipart/form-data">
                    <div class="contact-grids-tab">
                        <ul class="nav nav-underline" id="myTab2" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="info-tab2" data-bs-toggle="tab" data-bs-target="#basic-info2" type="button" role="tab" aria-selected="true">Basic Information</button>
                            </li>
                        </ul>
                    </div>
                    <div class="tab-content" id="myTabContent2">
                        <div class="tab-pane fade show active" id="basic-info2" role="tabpanel">
                            <div class="modal-body pb-0">
                                <div class="row">
                                    <input type="hidden" id="editUserId" name="UserId" />
                                    <div class="col-md-12">
                                        <div class="d-flex align-items-center flex-wrap row-gap-3 bg-light w-100 rounded p-3 mb-4">
                                            <div class="d-flex align-items-center justify-content-center avatar avatar-xxl rounded-circle border border-dashed me-2 flex-shrink-0 text-dark frames">
                                                <img src="assets/img/users/user-13.jpg" alt="img" class="rounded-circle">
                                            </div>
                                            <div class="profile-upload">
                                                <div class="mb-2">
                                                    <h6 class="mb-1">Upload Profile Image</h6>
                                                    <p class="fs-12">Image should be below 4 mb</p>
                                                </div>
                                                <div class="profile-uploader d-flex align-items-center">
                                                    <div class="drag-upload-btn btn btn-sm btn-primary me-2">
                                                        Upload
                                                        <input type="file" id="editProfilePicturePreview" name="ProfilePicture" class="form-control image-sign">
                                                    </div>
                                                    <a href="javascript:void(0);" class="btn btn-light btn-sm">Cancel</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                                            <input type="text" id="editFirstName" name="FirstName" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Last Name</label>
                                            <input type="text" id="editLastName" name="LastName" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" id="editEmail" name="Email" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Password <span class="text-danger">*</span></label>
                                            <div class="pass-group">
                                                <input type="password" id="editPasswordHash" name="PasswordHash" class="pass-input form-control">
                                                <span class="ti toggle-password ti-eye-off"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Joining Date <span class="text-danger">*</span></label>
                                            <div class="input-icon-end position-relative">
                                                <input type="text" id="editDateOfJoining" name="DateOfJoining" class="form-control datetimepicker">
                                                <span class="input-icon-addon"><i class="ti ti-calendar text-gray-7"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Birth Date <span class="text-danger">*</span></label>
                                            <div class="input-icon-end position-relative">
                                                <input type="text" id="editDateOfBirth" name="DateOfBirth" class="form-control datetimepicker">
                                                <span class="input-icon-addon"><i class="ti ti-calendar text-gray-7"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Role</label>
                                            <asp:DropDownList ID="ddlRoleEdit" CssClass="form-control" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Department</label>
                                            <asp:DropDownList ID="ddlDepartmentEdit" CssClass="form-control" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="managerContainer">
                                        <div class="mb-3">
                                            <label class="form-label">Manager</label>
                                            <asp:DropDownList ID="ddlManagerEdit" CssClass="form-control" runat="server" Enabled="false"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Designation</label>
                                            <asp:DropDownList ID="ddlDesignationEdit" CssClass="form-control" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                                            <input type="text" id="editPhoneNumber" name="PhoneNumber" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Address <span class="text-danger">*</span></label>
                                            <input type="text" id="editAddress" name="Address" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Gender</label>
                                            <select class="form-control" id="editGender" name="Gender">
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Status</label>
                                            <select class="form-control" id="editStatus" name="Status">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label class="form-label">About <span class="text-danger">*</span></label>
                                            <textarea id="editAboutEmployee" name="AboutEmployee" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-light border me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" id="saveEdit">Save</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- /Edit Employee Modal -->

    <!-- Add Employee Success Modal -->
    <div class="modal fade" id="success_modal" role="dialog">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="text-center p-3">
                        <span class="avatar avatar-lg avatar-rounded bg-success mb-3"><i class="ti ti-check fs-24"></i></span>
                        <h5 class="mb-2">Employee Added Successfully</h5>
                        <p class="mb-3">
                            Stephan Peralt has been added with Client ID : <span class="text-primary">#EMP - 0001</span>
                        </p>
                        <div>
                            <div class="row g-2">
                                <div class="col-6">
                                    <a href="employees.html" class="btn btn-dark w-100">Back to List</a>
                                </div>
                                <div class="col-6">
                                    <a href="employee-details.html" class="btn btn-primary w-100">Detail Page</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /Add Employee Success Modal -->

    <!-- Delete Modal -->
    <div class="modal fade" id="delete_modal">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <span class="avatar avatar-xl bg-transparent-danger text-danger mb-3">
                        <i class="ti ti-trash-x fs-36"></i>
                    </span>
                    <h4 class="mb-1">Confirm Delete</h4>
                    <p class="mb-3">You want to delete all the marked items, this cant be undone once you delete.</p>
                    <div class="d-flex justify-content-center">
                        <a href="javascript:void(0);" class="btn btn-light me-3" data-bs-dismiss="modal">Cancel</a>
                        <a href="employees-grid.html" class="btn btn-danger">Yes, Delete</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /Delete Modal -->

    <!-- Scripts -->
    <script src="<%= ResolveUrl("~/js/emp.js") %>"></script>
</asp:Content>