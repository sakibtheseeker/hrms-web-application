<%@ Page Title="User Profile" Language="C#" MasterPageFile="~/EmployeeMaster.Master" 
    AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="hrms_web_application.UserProfile" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">
        <!-- Breadcrumb -->
        <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
            <div class="my-auto mb-2">
                <h6 class="fw-medium d-inline-flex align-items-center mb-3 mb-sm-0">
                    <a href="#">Employee Details</a>
                </h6>
            </div>
            <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
                <div class="head-icons ms-2">
                    <a href="javascript:void(0);" class="" data-bs-toggle="tooltip" data-bs-placement="top"
                       data-bs-original-title="Collapse" id="collapse-header">
                        <i class="ti ti-chevrons-up"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- /Breadcrumb -->

        <div class="row">
            <!-- Left Sidebar - Employee Profile -->
            <div class="col-xl-4">
                <div class="card card-bg-1">
                    <div class="card-body p-0">
                        <span class="avatar avatar-xl avatar-rounded border border-2 border-white m-auto d-flex mb-2">
                            <asp:Image ID="imgProfile" runat="server" CssClass="w-auto h-auto" AlternateText="Profile" />
                        </span>
                        <div class="text-center px-3 pb-3 border-bottom">
                            <div class="mb-3">
                                <h5 class="d-flex align-items-center justify-content-center mb-1">
                                    <asp:Label ID="lblFullName" runat="server"></asp:Label>
                                    <i class="ti ti-discount-check-filled text-success ms-1"></i>
                                </h5>
                                <span class="badge badge-soft-dark fw-medium me-2">
                                    <i class="ti ti-point-filled me-1"></i>
                                    <asp:Label ID="lblDesignation" runat="server"></asp:Label>
                                </span>
                            </div>
                            <div>
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="d-inline-flex align-items-center"><i class="ti ti-id me-2"></i>Client ID</span>
                                    <p class="text-dark"><asp:Label ID="lblUserId" runat="server"></asp:Label></p>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="d-inline-flex align-items-center"><i class="ti ti-star me-2"></i>Department</span>
                                    <p class="text-dark"><asp:Label ID="lblDepartment" runat="server"></asp:Label></p>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="d-inline-flex align-items-center"><i class="ti ti-calendar-check me-2"></i>Date Of Join</span>
                                    <p class="text-dark"><asp:Label ID="lblDOJ" runat="server"></asp:Label></p>
                                </div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <span class="d-inline-flex align-items-center"><i class="ti ti-calendar-check me-2"></i>Report Office</span>
                                    <p class="text-gray-9 mb-0"><asp:Label ID="lblReportManager" runat="server"></asp:Label></p>
                                </div>
                                <div class="row gx-2 mt-3">
                                    <div class="col-12">
                                        <a href="#" class="btn btn-dark w-100" data-bs-toggle="modal" data-bs-target="#edit_employee">
                                            <i class="ti ti-edit me-1"></i>Edit Info
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 border-bottom">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <h6>Basic information</h6>
                                <a href="javascript:void(0);" class="btn btn-icon btn-sm" data-bs-toggle="modal" data-bs-target="#edit_employee">
                                    <i class="ti ti-edit"></i>
                                </a>
                            </div>
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="d-inline-flex align-items-center"><i class="ti ti-phone me-2"></i>Phone</span>
                                <p class="text-dark"><asp:Label ID="lblPhone" runat="server"></asp:Label></p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="d-inline-flex align-items-center"><i class="ti ti-mail-check me-2"></i>Email</span>
                                <a href="javascript:void(0);" class="text-info d-inline-flex align-items-center">
                                    <asp:Label ID="lblEmail" runat="server"></asp:Label>
                                    <i class="ti ti-copy text-dark ms-2"></i>
                                </a>
                            </div>
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="d-inline-flex align-items-center"><i class="ti ti-gender-male me-2"></i>Gender</span>
                                <p class="text-dark text-end"><asp:Label ID="lblGender" runat="server"></asp:Label></p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span class="d-inline-flex align-items-center"><i class="ti ti-cake me-2"></i>Birthday</span>
                                <p class="text-dark text-end"><asp:Label ID="lblDOB" runat="server"></asp:Label></p>
                            </div>
                            <div class="d-flex align-items-center justify-content-between">
                                <span class="d-inline-flex align-items-center"><i class="ti ti-map-pin-check me-2"></i>Address</span>
                                <p class="text-dark text-end"><asp:Label ID="lblAddress" runat="server"></asp:Label></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side - Accordion Details -->
            <div class="col-xl-8">
                <div class="tab-content custom-accordion-items">
                    <div class="tab-pane active show">
                        <div class="accordion accordions-items-seperate" id="accordionExample">

                            <!-- About Employee -->
                            <div class="accordion-item">
                                <div class="accordion-header" id="headingOne">
                                    <div class="accordion-button">
                                        <div class="d-flex align-items-center flex-fill">
                                            <h5>About Employee</h5>
                                            <a href="#" class="btn btn-sm btn-icon ms-auto" data-bs-toggle="modal" data-bs-target="#edit_employee">
                                                <i class="ti ti-edit"></i>
                                            </a>
                                            <a href="#" class="d-flex align-items-center collapsed collapse-arrow"
                                               data-bs-toggle="collapse" data-bs-target="#primaryBorderOne">
                                                <i class="ti ti-chevron-down fs-18"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div id="primaryBorderOne" class="accordion-collapse collapse show border-top" data-bs-parent="#accordionExample">
                                    <div class="accordion-body mt-2">
                                        <asp:Label ID="lblAbout" runat="server" CssClass="text-gray-9"></asp:Label>
                                    </div>
                                </div>
                            </div>

                            <!-- Bank Information -->
                            <div class="accordion-item">
                                <div class="accordion-header" id="headingTwo">
                                    <div class="accordion-button">
                                        <div class="d-flex align-items-center flex-fill">
                                            <h5>Bank Information</h5>
                                            <a href="#" class="btn btn-icon btn-sm ms-auto" data-bs-toggle="modal" data-bs-target="#addBankDetailsModal">
                                                <i class="ti ti-plus"></i>
                                            </a>
                                            <a href="#" class="d-flex align-items-center collapsed collapse-arrow"
                                               data-bs-toggle="collapse" data-bs-target="#primaryBorderTwo">
                                                <i class="ti ti-chevron-down fs-18"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div id="primaryBorderTwo" class="accordion-collapse collapse border-top" data-bs-parent="#accordionExample">
                                    <div class="accordion-body">
                                        <div class="row">
                                            <asp:Repeater ID="rptBankDetails" runat="server">
                                                <ItemTemplate>
                                                    <div class="col-md-3"><span>Bank Id</span><h6><%# Eval("BankDetailId") %></h6></div>
                                                    <div class="col-md-3"><span>Bank Name</span><h6><%# Eval("BankName") %></h6></div>
                                                    <div class="col-md-3"><span>Account No</span><h6><%# Eval("AccountNumber") %></h6></div>
                                                    <div class="col-md-3"><span>IFSC Code</span><h6><%# Eval("IFSCCode") %></h6></div>
                                                    <div class="col-md-3"><span>Branch</span><h6><%# Eval("BranchName") %></h6></div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Family Information -->
                            <div class="accordion-item">
                                <div class="accordion-header" id="headingThree">
                                    <div class="accordion-button">
                                        <div class="d-flex align-items-center justify-content-between flex-fill">
                                            <h5>Family Information</h5>
                                            <div class="d-flex">
                                                <a href="#" class="btn btn-icon btn-sm" data-bs-toggle="modal" data-bs-target="#addFamilyDetailsModal">
                                                    <i class="ti ti-plus"></i>
                                                </a>
                                                <a href="#" class="d-flex align-items-center collapsed collapse-arrow"
                                                   data-bs-toggle="collapse" data-bs-target="#primaryBorderThree">
                                                    <i class="ti ti-chevron-down fs-18"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="primaryBorderThree" class="accordion-collapse collapse border-top" data-bs-parent="#accordionExample">
                                    <div class="accordion-body">
                                        <div class="row">
                                            <asp:Repeater ID="rptFamilyDetails" runat="server">
                                                <ItemTemplate>
                                                    <div class="col-md-3"><span>Family Id</span><h6><%# Eval("FamilyDetailId") %></h6></div>
                                                    <div class="col-md-3"><span>Name</span><h6><%# Eval("Name") %></h6></div>
                                                    <div class="col-md-3"><span>Relationship</span><h6><%# Eval("Relation") %></h6></div>
                                                    <div class="col-md-3"><span>Date of birth</span><h6><%# Eval("DateOfBirth", "{0:dd MMM yyyy}") %></h6></div>
                                                    <div class="col-md-3"><span>Phone</span><h6><%# Eval("phone") %></h6></div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Education & Experience -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="accordion-item">
                                        <div class="accordion-header" id="headingFour">
                                            <div class="accordion-button">
                                                <div class="d-flex align-items-center justify-content-between flex-fill">
                                                    <h5>Education Details</h5>
                                                    <div class="d-flex">
                                                        <a href="#" class="btn btn-icon btn-sm" data-bs-toggle="modal" data-bs-target="#addEducationDetailsModal">
                                                            <i class="ti ti-plus"></i>
                                                        </a>
                                                        <a href="#" class="d-flex align-items-center collapsed collapse-arrow"
                                                           data-bs-toggle="collapse" data-bs-target="#primaryBorderFour">
                                                            <i class="ti ti-chevron-down fs-18"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="primaryBorderFour" class="accordion-collapse collapse border-top" data-bs-parent="#accordionExample">
                                            <div class="accordion-body">
                                                <asp:Repeater ID="rptEducation" runat="server">
                                                    <ItemTemplate>
                                                        <div class="mb-3">
                                                            <div class="d-flex align-items-center justify-content-between">
                                                                <div>
                                                                    <span class="fw-normal"><%# Eval("EducationDetailsId") %> - <%# Eval("UniversityName") %></span>
                                                                    <h6 class="mt-1"><%# Eval("EducationType") %></h6>
                                                                </div>
                                                                <p class="text-dark"><%# Eval("startdate", "{0:dd MMM yyyy}") %> - <%# Eval("enddate", "{0:dd MMM yyyy}") %></p>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="accordion-item">
                                        <div class="accordion-header" id="headingFive">
                                            <div class="accordion-button">
                                                <div class="d-flex align-items-center justify-content-between flex-fill">
                                                    <h5>Experience</h5>
                                                    <div class="d-flex">
                                                        <a href="#" class="btn btn-icon btn-sm" data-bs-toggle="modal" data-bs-target="#addExperienceDetailsModal">
                                                            <i class="ti ti-plus"></i>
                                                        </a>
                                                        <a href="#" class="d-flex align-items-center collapsed collapse-arrow"
                                                           data-bs-toggle="collapse" data-bs-target="#primaryBorderFive">
                                                            <i class="ti ti-chevron-down fs-18"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="primaryBorderFive" class="accordion-collapse collapse border-top" data-bs-parent="#accordionExample">
                                            <div class="accordion-body">
                                                <asp:Repeater ID="rptExperience" runat="server">
                                                    <ItemTemplate>
                                                        <div class="mb-3">
                                                            <div class="d-flex align-items-center justify-content-between">
                                                                <div>
                                                                    <h6 class="fw-medium"><%# Eval("ExperienceId") %> . <%# Eval("CompanyName") %></h6>
                                                                    <span class="badge bg-secondary-transparent mt-1">
                                                                        <i class="ti ti-point-filled me-1"></i><%# Eval("DesignationName") %>
                                                                    </span>
                                                                </div>
                                                                <p class="text-dark"><%# Eval("FromDate", "{0:dd MMM yyyy}") %> - <%# Eval("ToDate", "{0:dd MMM yyyy}") %></p>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ====================== ALL MODALS WITH SERVER CONTROLS ====================== -->

    <!-- Edit Employee Profile -->
    <div class="modal fade" id="edit_employee">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Employee</h4>
                    <button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button>
                </div>
                <asp:Panel runat="server" DefaultButton="btnSaveProfile">
                    <div class="modal-body pb-0">
                        <div class="row">
                            <div class="col-md-12 mb-4">
                                <div class="d-flex align-items-center flex-wrap row-gap-3 bg-light rounded p-3">
                                    <div class="avatar avatar-xxl rounded-circle border border-dashed me-3">
                                        <asp:Image ID="imgEditProfile" runat="server" CssClass="rounded-circle" />
                                    </div>
                                    <div class="profile-upload">
                                        <h6 class="mb-1">Upload Profile Image</h6>
                                        <p class="fs-12">Image should be below 4 MB</p>
                                        <div class="profile-uploader d-flex align-items-center">
                                            <asp:FileUpload ID="fuProfilePicture" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <asp:HiddenField ID="hdnUserId" runat="server" />

                            <div class="col-md-6"><div class="mb-3"><label>First Name <span class="text-danger">*</span></label><asp:TextBox ID="txtFirstName" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Last Name</label><asp:TextBox ID="txtLastName" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Date of Birth <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtDOB" CssClass="form-control datetimepicker" runat="server" placeholder="dd/mm/yyyy" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Email <span class="text-danger">*</span></label><asp:TextBox ID="txtEmail" CssClass="form-control" runat="server" TextMode="Email" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Phone Number <span class="text-danger">*</span></label><asp:TextBox ID="txtPhone" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Address <span class="text-danger">*</span></label><asp:TextBox ID="txtAddress" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>About</label><asp:TextBox ID="txtAbout" CssClass="form-control" TextMode="MultiLine" Rows="4" runat="server" /></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-light border me-2" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveProfile" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveProfile_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Add Bank Details -->
    <div class="modal fade" id="addBankDetailsModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header"><h4 class="modal-title">Add Bank Details</h4><button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button></div>
                <asp:Panel runat="server" DefaultButton="btnSaveBank">
                    <div class="modal-body pb-0">
                        <div class="row">
                            <asp:HiddenField ID="hdnBankUserId" runat="server" />
                            <div class="col-md-12"><div class="mb-3"><label>Bank Name <span class="text-danger">*</span></label><asp:TextBox ID="txtAddBankName" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>Account Number <span class="text-danger">*</span></label><asp:TextBox ID="txtAddAccountNo" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>IFSC Code <span class="text-danger">*</span></label><asp:TextBox ID="txtAddIFSC" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>Branch Name <span class="text-danger">*</span></label><asp:TextBox ID="txtAddBranch" CssClass="form-control" runat="server" /></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white border me-2" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveBank" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveBank_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Add Family Details -->
    <div class="modal fade" id="addFamilyDetailsModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header"><h4 class="modal-title">Add Family Member</h4><button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button></div>
                <asp:Panel runat="server" DefaultButton="btnSaveFamily">
                    <div class="modal-body pb-0">
                        <div class="row">
                            <asp:HiddenField ID="hdnFamilyUserId" runat="server" />
                            <div class="col-md-12"><div class="mb-3"><label>Name <span class="text-danger">*</span></label><asp:TextBox ID="txtAddFamilyName" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>Relationship <span class="text-danger">*</span></label><asp:TextBox ID="txtAddRelation" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>Phone</label><asp:TextBox ID="txtAddFamilyPhone" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><label>Date of Birth <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtAddFamilyDOB" CssClass="form-control datetimepicker" runat="server" placeholder="dd/mm/yyyy" /></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white border me-2" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveFamily" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveFamily_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Add Education -->
    <div class="modal fade" id="addEducationDetailsModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header"><h4 class="modal-title">Add Education</h4><button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button></div>
                <asp:Panel runat="server" DefaultButton="btnSaveEducation">
                    <div class="modal-body pb-0">
                        <div class="row">
                            <asp:HiddenField ID="hdnEduUserId" runat="server" />
                            <div class="col-md-6"><div class="mb-3"><label>Institution Name <span class="text-danger">*</span></label><asp:TextBox ID="txtAddUniversity" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Course/Degree <span class="text-danger">*</span></label><asp:TextBox ID="txtAddCourse" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Start Date <span class="text-danger">*</span></label><asp:TextBox ID="txtAddEduStart" CssClass="form-control datetimepicker" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>End Date <span class="text-danger">*</span></label><asp:TextBox ID="txtAddEduEnd" CssClass="form-control datetimepicker" runat="server" /></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white border me-2" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveEducation" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveEducation_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Add Experience -->
    <div class="modal fade" id="addExperienceDetailsModal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header"><h4 class="modal-title">Add Experience</h4><button type="button" class="btn-close custom-btn-close" data-bs-dismiss="modal"><i class="ti ti-x"></i></button></div>
                <asp:Panel runat="server" DefaultButton="btnSaveExperience">
                    <div class="modal-body pb-0">
                        <div class="row">
                            <asp:HiddenField ID="hdnExpUserId" runat="server" />
                            <div class="col-md-6"><div class="mb-3"><label>Company Name <span class="text-danger">*</span></label><asp:TextBox ID="txtAddCompany" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>Designation <span class="text-danger">*</span></label><asp:TextBox ID="txtAddDesignation" CssClass="form-control" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>From Date <span class="text-danger">*</span></label><asp:TextBox ID="txtAddExpFrom" CssClass="form-control datetimepicker" runat="server" /></div></div>
                            <div class="col-md-6"><div class="mb-3"><label>To Date</label><asp:TextBox ID="txtAddExpTo" CssClass="form-control datetimepicker" runat="server" /></div></div>
                            <div class="col-md-12"><div class="mb-3"><asp:CheckBox ID="chkCurrentJob" runat="server" Text="Currently working here" CssClass="form-check-input" /></div></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white border me-2" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveExperience" CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSaveExperience_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="success_modal">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content">
                <div class="modal-body text-center p-4">
                    <span class="avatar avatar-lg avatar-rounded bg-success mb-3"><i class="ti ti-check fs-24"></i></span>
                    <h5>Changes Saved Successfully</h5>
                    <p>Your profile has been updated.</p>
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>