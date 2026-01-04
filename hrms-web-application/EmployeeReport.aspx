<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeReport.aspx.cs" Inherits="hrms_web_application.EmployeeReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">



		<div class="content">

    <!-- Breadcrumb -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Employee Report</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">
                        HR
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Employee Report</li>
                </ol>
            </nav>
        </div>
        <div class="d-flex my-xl-auto right-content align-items-center flex-wrap ">
            <div class="mb-2">
                <div class="dropdown">
                    <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                        <i class="ti ti-file-export me-1"></i>Export
                    </a>
                    <ul class="dropdown-menu  dropdown-menu-end p-3">
                        <li>
                            <a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-xls me-1"></i>Export as Excel </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="head-icons ms-2">
                <a href="javascript:void(0);" class="" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="Collapse" id="collapse-header">
                    <i class="ti ti-chevrons-up"></i>
                </a>
            </div>
        </div>
    </div>
    <!-- /Breadcrumb -->

    <!-- Summary Cards -->
    <div class="row">
        <div class="col-xl-6 d-flex">
            <div class="row flex-fill">

                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="overflow-hidden d-flex mb-2 align-items-center">
                                <span class="me-2"><img src="assets/img/reports-img/employee-report-icon.svg" alt="Img" class="img-fluid"></span>
                                <div>
                                    <p class="fs-14 fw-normal mb-1 text-truncate">Total Employee</p>
                                    <h5>
                                        <asp:Label ID="Label1" runat="server"></asp:Label>
                                    </h5>
                                </div>
                            </div>
                            <div>
                                <p class="fs-12 fw-normal d-flex align-items-center text-truncate "><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+20.01%</span>from last week</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="overflow-hidden d-flex mb-2 align-items-center">
                                <span class="me-2"><img src="assets/img/reports-img/employee-report-success.svg" alt="Img" class="img-fluid"></span>
                                <div>
                                    <p class="fs-14 fw-normal mb-1 text-truncate">Active Employee</p>
                                    <h5>
                                        <asp:Label ID="Label2" runat="server"></asp:Label>
                                    </h5>
                                </div>
                            </div>
                            <div>
                                <p class="fs-12 fw-normal d-flex align-items-center text-truncate "><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+20.01%</span>from last week</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="overflow-hidden d-flex mb-2 align-items-center">
                                <span class="me-2"><img src="assets/img/reports-img/employee-report-info.svg" alt="Img" class="img-fluid"></span>
                                <div>
                                    <p class="fs-14 fw-normal mb-1 text-truncate">New Employee</p>
                                    <h5>
                                        <asp:Label ID="Label3" runat="server"></asp:Label>
                                    </h5>
                                </div>
                            </div>
                            <div>
                                <p class="fs-12 fw-normal d-flex align-items-center text-truncate "><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+20.01%</span>from last week</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="overflow-hidden d-flex mb-2 align-items-center">
                                <span class="me-2"><img src="assets/img/reports-img/employee-report-danger.svg" alt="Img" class="img-fluid"></span>
                                <div>
                                    <p class="fs-14 fw-normal mb-1 text-truncate">Inactive Employee</p>
                                    <h5>
                                        <asp:Label ID="Label4" runat="server"></asp:Label>
                                    </h5>
                                </div>
                            </div>
                            <div>
                                <p class="fs-12 fw-normal d-flex align-items-center text-truncate "><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+20.01%</span>from last week</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="col-xl-6 d-flex">
            <div class="card flex-fill">
                <div class="card-header border-0 pb-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center row-gap-2">
                        <div class="d-flex align-items-center ">
                            <span class="me-2"><i class="ti ti-chart-bar text-danger"></i></span>
                            <h5>Employee </h5>
                        </div>
                        <div class="d-flex align-items-center">
                            <p class="d-inline-flex align-items-center me-3 mb-0">
                                <i class="ti ti-square-filled fs-12 text-success me-2"></i>
                                Active Employees
                            </p>
                            <p class="d-inline-flex align-items-center">
                                <i class="ti ti-square-filled fs-12 text-gray-1 me-2 mb-0"></i>
                                Inactive Employees
                            </p>
                        </div>
                        <div class="dropdown">
                            <a href="javascript:void(0);" class="dropdown-toggle btn btn-sm fs-12 btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                                This Year
                            </a>
                            <ul class="dropdown-menu  dropdown-menu-end p-2">
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-body py-0">
                    <div id="employee-reports"></div>
                </div>
            </div>
        </div>

    </div>

    <!-- Employees List Card -->
    <div class="card">

        <!-- Row 1: Title left, Status + Sort right -->
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">

                <!-- Title Left -->
                <h5 class="mb-0">Employees List</h5>

                <!-- Filters Right -->
                <div class="d-flex flex-wrap align-items-center">
                    <!-- Status Dropdown -->
                    <div class="me-2 mb-2">
                        <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-select"
                            AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                            <asp:ListItem Text="All" Value=""></asp:ListItem>
                            <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                            <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Sort Dropdown -->
                    <div class="dropdown me-2 mb-2">
                        <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center"
                           data-bs-toggle="dropdown">
                            Sort By
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">Recently Added</a></li>
                            <li>
                                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="dropdown-item rounded-1"
                                                OnClick="LinkButton1_Click">Ascending</asp:LinkButton>
                            </li>
                            <li>
                                <asp:LinkButton ID="LinkButton2" runat="server" CssClass="dropdown-item rounded-1"
                                                OnClick="LinkButton2_Click">Descending</asp:LinkButton>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>

            <!-- Row 2: Search box right -->
            <div class="d-flex justify-content-end mb-0">
                <div style="width: 250px;">
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"
                                 Placeholder="Search employees..." AutoPostBack="true"
                                 OnTextChanged="TextBox1_TextChanged" />
                </div>
            </div>
        </div>

        <!-- Grid -->
        <div class="card-body p-0">
            <div class="custom-datatable-filter table-responsive">
                <asp:GridView 
                    ID="gvEmployeeReport"
                    runat="server"
                    CssClass="table table-striped table-hover mb-0"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    EmptyDataText="No employees found">

                    <HeaderStyle CssClass="table-light" />

                    <Columns>
                        <asp:BoundField DataField="EmpId" HeaderText="User ID" />
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:BoundField DataField="Phone" HeaderText="Phone Number" />
                        <asp:BoundField DataField="JoiningDate" HeaderText="Date of Joining" 
                                        DataFormatString="{0:dd-MM-yyyy}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusBadge(Eval("Status").ToString()) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</div>
    </asp:Content>
