<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" 
    CodeBehind="EmployeeDashboard.aspx.cs" Inherits="hrms_web_application.EmployeeDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">
        <!-- Breadcrumb -->
        <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
            <div class="my-auto mb-2">
                <h2 class="mb-1">Employee Dashboard</h2>
                <nav>
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="index.html"><i class="ti ti-smart-home"></i></a>
                        </li>
                        <li class="breadcrumb-item">Dashboard</li>
                        <li class="breadcrumb-item active" aria-current="page">Employee Dashboard</li>
                    </ol>
                </nav>
            </div>
            <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
                <div class="me-2 mb-2">
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-file-export me-1"></i>Export
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-xls me-1"></i>Export as Excel</a></li>
                        </ul>
                    </div>
                </div>
                <div class="input-icon w-120 position-relative mb-2">
                    <span class="input-icon-addon"><i class="ti ti-calendar text-gray-9"></i></span>
                    <asp:TextBox ID="txtDateFilter" CssClass="form-control datetimepicker" runat="server" Text="15 Apr 2025"></asp:TextBox>
                </div>
                <div class="ms-2 head-icons">
                    <a href="javascript:void(0);" class="" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="Collapse" id="collapse-header">
                        <i class="ti ti-chevrons-up"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- /Breadcrumb -->

        <!-- Dynamic Alert (e.g., latest approved leave request) -->
        <asp:Panel ID="pnlAlert" runat="server" CssClass="alert bg-secondary-transparent alert-dismissible fade show mb-4" Visible="false">
            <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            <button type="button" class="btn-close fs-14" data-bs-dismiss="alert" aria-label="Close"><i class="ti ti-x"></i></button>
        </asp:Panel>

        <div class="row">
            <!-- Employee Profile Card -->
            <div class="col-xl-4 d-flex">
                <div class="card position-relative flex-fill">
                    <div class="card-header bg-dark">
                        <div class="d-flex align-items-center">
                            <span class="avatar avatar-lg avatar-rounded border border-white border-2 flex-shrink-0 me-2">
                                <asp:Image ID="imgProfile" runat="server" ImageUrl="/assets/img/profiles/default.png"
 AlternateText="Img" />
                            </span>
                            <div>
                                <h5 class="text-white mb-1"><asp:Label ID="lblEmployeeName" runat="server"></asp:Label></h5>
                                <div class="d-flex align-items-center">
                                    <p class="text-white fs-12 mb-0"><asp:Label ID="lblDesignation" runat="server"></asp:Label></p>
                                    <span class="mx-1"><i class="ti ti-point-filled text-primary"></i></span>
                                    <p class="fs-12"><asp:Label ID="lblDepartment" runat="server"></asp:Label></p>
                                </div>
                            </div>
                        </div>
                        <a href="#" class="btn btn-icon btn-sm text-white rounded-circle edit-top"><i class="ti ti-edit"></i></a>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="d-block mb-1 fs-13">Phone Number</span>
                            <p class="text-gray-9"><asp:Label ID="lblPhone" runat="server"></asp:Label></p>
                        </div>
                        <div class="mb-3">
                            <span class="d-block mb-1 fs-13">Email Address</span>
                            <p class="text-gray-9"><asp:Label ID="lblEmail" runat="server"></asp:Label></p>
                        </div>
                        <div class="mb-3">
                            <span class="d-block mb-1 fs-13">Report Office</span>
                            <p class="text-gray-9"><asp:Label ID="lblReportingManager" runat="server"></asp:Label></p>
                        </div>
                        <div>
                            <span class="d-block mb-1 fs-13">Joined on</span>
                            <p class="text-gray-9"><asp:Label ID="lblJoinDate" runat="server"></asp:Label></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Attendance Summary (Left) -->
            <div class="col-xl-5 d-flex">
                <div class="card flex-fill">
                    <div class="card-header">
                        <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                            <h5>Attendance Summary</h5>
                            <div class="dropdown">
                                <asp:LinkButton ID="lbYear" CssClass="btn btn-white border btn-sm d-inline-flex align-items-center" runat="server" data-bs-toggle="dropdown">
                                    <i class="ti ti-calendar me-1"></i><asp:Label ID="lblSelectedYear" runat="server" Text="2024"></asp:Label>
                                </asp:LinkButton>
                                <ul class="dropdown-menu dropdown-menu-end p-3">
                                    <li><a href="#" class="dropdown-item rounded-1">2024</a></li>
                                    <li><a href="#" class="dropdown-item rounded-1">2023</a></li>
                                    <li><a href="#" class="dropdown-item rounded-1">2022</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <p class="d-flex align-items-center"><i class="ti ti-circle-filled fs-8 text-dark me-1"></i>
                                        <span class="text-gray-9 fw-semibold me-1"><asp:Label ID="lblOnTime" runat="server"></asp:Label></span> on time
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <p class="d-flex align-items-center"><i class="ti ti-circle-filled fs-8 text-success me-1"></i>
                                        <span class="text-gray-9 fw-semibold me-1"><asp:Label ID="lblLate" runat="server"></asp:Label></span> Late Attendance
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <p class="d-flex align-items-center"><i class="ti ti-circle-filled fs-8 text-primary me-1"></i>
                                        <span class="text-gray-9 fw-semibold me-1"><asp:Label ID="lblWFH" runat="server"></asp:Label></span> Work From Home
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <p class="d-flex align-items-center"><i class="ti ti-circle-filled fs-8 text-danger me-1"></i>
                                        <span class="text-gray-9 fw-semibold me-1"><asp:Label ID="lblAbsent" runat="server"></asp:Label></span> Absent
                                    </p>
                                </div>
                                <div>
                                    <p class="d-flex align-items-center"><i class="ti ti-circle-filled fs-8 text-warning me-1"></i>
                                        <span class="text-gray-9 fw-semibold me-1"><asp:Label ID="lblSickLeave" runat="server"></asp:Label></span> Sick Leave
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3 d-flex justify-content-md-end">
                                    <div id="leaves_chart"></div> <!-- Chart will be populated via JS using data from code-behind -->
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="todo1" checked>
                                    <label class="form-check-label" for="todo1">
                                        Better than <span class="text-gray-9"><asp:Label ID="lblPerformancePercent" runat="server"></asp:Label></span> of Employees
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Leave Details (Right) -->
            <div class="col-xl-3 d-flex">
                <div class="card flex-fill">
                    <div class="card-header">
                        <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                            <h5>Leave Details</h5>
                            <div class="dropdown">
                                <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                                    <i class="ti ti-calendar me-1"></i><asp:Label ID="lblLeaveYear" runat="server" Text="2024"></asp:Label>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end p-3">
                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a></li>
                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a></li>
                                    <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Total Leaves</span><h4><asp:Label ID="lblTotalLeaves" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Taken</span><h4><asp:Label ID="lblTakenLeaves" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Absent</span><h4><asp:Label ID="lblAbsentDays" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Request</span><h4><asp:Label ID="lblPendingRequests" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Worked Days</span><h4><asp:Label ID="lblWorkedDays" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-6"><div class="mb-4"><span class="d-block mb-1">Loss of Pay</span><h4><asp:Label ID="lblLOP" runat="server"></asp:Label></h4></div></div>
                            <div class="col-sm-12">
                                <div>
                                    <a href="#" class="btn btn-dark w-100" data-bs-toggle="modal" data-bs-target="#add_leaves">Apply New Leave</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Attendance & Hours Section -->
        <div class="row">
            <div class="col-xl-4 d-flex">
                <div class="card flex-fill border-primary attendance-bg">
                    <div class="card-body">
                        <div class="mb-4 text-center">
                            <h6 class="fw-medium text-gray-5 mb-1">Attendance</h6>
                            <h4><asp:Label ID="lblCurrentPunchTime" runat="server"></asp:Label></h4>
                        </div>
                        <div class="attendance-circle-progress attendance-progress mx-auto mb-3" data-value='65'>
                            <!-- Progress circle handled via JS -->
                            <div class="total-work-hours text-center w-100">
                                <span class="fs-13 d-block mb-1">Total Hours</span>
                                <h6><asp:Label ID="lblTodayHours" runat="server"></asp:Label></h6>
                            </div>
                        </div>
                        <div class="text-center">
                            <div class="badge badge-dark badge-md mb-3">
                                Production : <asp:Label ID="lblProductionHours" runat="server"></asp:Label> hrs
                            </div>
                            <h6 class="fw-medium d-flex align-items-center justify-content-center mb-4">
                                <i class="ti ti-fingerprint text-primary me-1"></i>
                                Punch In at <asp:Label ID="lblPunchInTime" runat="server"></asp:Label>
                            </h6>
                            <a href="#" class="btn btn-primary w-100">Punch Out</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hours Cards -->
            <div class="col-xl-8 d-flex">
                <div class="row flex-fill">
                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="border-bottom mb-3 pb-2">
                                    <span class="avatar avatar-sm bg-primary mb-2"><i class="ti ti-clock-stop"></i></span>
                                    <h2 class="mb-2"><asp:Label ID="lblTodayHoursValue" runat="server"></asp:Label> / <span class="fs-20 text-gray-5">9</span></h2>
                                    <p class="fw-medium text-truncate">Total Hours Today</p>
                                </div>
                                <div>
                                    <p class="d-flex align-items-center fs-13">
                                        <span class="avatar avatar-xs rounded-circle bg-success flex-shrink-0 me-2"><i class="ti ti-arrow-up fs-12"></i></span>
                                        <span><asp:Label ID="lblTodayChange" runat="server"></asp:Label> This Week</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Repeat similar pattern for Week, Month, Overtime cards -->
                    <!-- ... (similar dynamic labels for other three cards) -->
                </div>
            </div>
        </div>

        <!-- Projects Section -->
        <div class="row">
            <div class="col-xl-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-header">
                        <h5>Projects</h5>
                        <!-- Dropdown for filter -->
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptProjects" runat="server">
                            <ItemTemplate>
                                <div class="col-md-6">
                                    <div class="card mb-4 shadow-none mb-md-0">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center justify-content-between mb-3">
                                                <h6><%# Eval("ProjectName") %></h6>
                                                <!-- dropdown -->
                                            </div>
                                            <div>
                                                <div class="d-flex align-items-center mb-3">
                                                    <a href="javascript:void(0);" class="avatar">
                                                        <img src='<%# Eval("LogoPath") %>' 
     class="img-fluid rounded-circle"
     onerror="this.src='assets/img/default-project.png';" />

                                                    </a>
                                                    <div class="ms-2">
                                                        <h6 class="fw-normal">
    <a href="javascript:void(0);"><%# Eval("ManagerName") %></a>
</h6>
<span class="fs-13 d-block">Project Manager</span>

                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center mb-3">
                                                    <a href="javascript:void(0);" class="avatar bg-soft-primary rounded-circle">
                                                        <i class="ti ti-calendar text-primary fs-16"></i>
                                                    </a>
                                                    <div class="ms-2">
                                                        <h6 class="fw-normal">
    <%# Eval("EndDate", "{0:dd MMM yyyy}") %>
</h6>
<span class="fs-13 d-block">End Date</span>

                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center justify-content-between bg-transparent-light border border-dashed rounded p-2 mb-3">
                                                    <div class="d-flex align-items-center">
                                                        <span class="avatar avatar-sm bg-success-transparent rounded-circle me-1"><i class="ti ti-checklist fs-16"></i></span>
                                                        <p class="text-muted">
    Project Status :
    <span class="fw-semibold"><%# Eval("Status") %></span>
</p>

                                                    </div>
                                                    <!-- Team avatars repeater -->
                                                </div>
                                               
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <!-- Tasks Section -->
<div class="col-xl-6 d-flex">
    <div class="card flex-fill">
        <div class="card-header">
            <h5>Tasks</h5>
        </div>

        <div class="card-body">

            <asp:Repeater ID="rptTasks" runat="server">
                <ItemTemplate>
                    <div class="list-group-item border rounded mb-3 p-2">
                        <h6 class="mb-1"><%# Eval("Title") %></h6>

                        <p class="mb-1 text-muted">
                            Priority: <%# Eval("Priority") %>
                        </p>

                        <p class="mb-1">
                            Status:
                            <span class="badge bg-info">
                                <%# Eval("Status") %>
                            </span>
                        </p>

                        <p class="mb-0 text-muted">
                            Deadline:
                            <%# Eval("Deadline", "{0:dd MMM yyyy}") %>
                        </p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>
</div>

        </div>

      <!-- Row 1: Performance | My Skills | Birthday/Policy/Holiday (Horizontal) -->
<div class="row">
    <!-- Performance Card -->
    <div class="col-xl-4 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                    <h5>Performance</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>2024
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div>
                    <div class="bg-light d-flex align-items-center rounded p-2">
                        <h3 class="me-2">98%</h3>
                        <span class="badge badge-outline-success bg-success-transparent rounded-pill me-1">12%</span>
                        <span>vs last years</span>
                    </div>
                    <div id="performance_chart2"></div>
                </div>
            </div>
        </div>
    </div>
    <!-- /Performance Card -->

    <!-- My Skills Card -->
    <div class="col-xl-4 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                    <h5>My Skills</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>2024
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div>
                    <div class="border border-dashed bg-transparent-light rounded p-2 mb-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="d-block border border-2 h-12 border-primary rounded-5 me-2"></span>
                                <div>
                                    <h6 class="fw-medium mb-1">Figma</h6>
                                    <p>Updated : 15 May 2025</p>
                                </div>
                            </div>
                            <div class="circle-progress circle-progress-md" data-value='95'>
                                <span class="progress-left"><span class="progress-bar border-primary"></span></span>
                                <span class="progress-right"><span class="progress-bar border-primary"></span></span>
                                <div class="progress-value">95%</div>
                            </div>
                        </div>
                    </div>
                    <div class="border border-dashed bg-transparent-light rounded p-2 mb-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="d-block border border-2 h-12 border-success rounded-5 me-2"></span>
                                <div>
                                    <h6 class="fw-medium mb-1">HTML</h6>
                                    <p>Updated : 12 May 2025</p>
                                </div>
                            </div>
                            <div class="circle-progress circle-progress-md" data-value='85'>
                                <span class="progress-left"><span class="progress-bar border-success"></span></span>
                                <span class="progress-right"><span class="progress-bar border-success"></span></span>
                                <div class="progress-value">85%</div>
                            </div>
                        </div>
                    </div>
                    <div class="border border-dashed bg-transparent-light rounded p-2 mb-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="d-block border border-2 h-12 border-purple rounded-5 me-2"></span>
                                <div>
                                    <h6 class="fw-medium mb-1">CSS</h6>
                                    <p>Updated : 12 May 2025</p>
                                </div>
                            </div>
                            <div class="circle-progress circle-progress-md" data-value='70'>
                                <span class="progress-left"><span class="progress-bar border-purple"></span></span>
                                <span class="progress-right"><span class="progress-bar border-purple"></span></span>
                                <div class="progress-value">70%</div>
                            </div>
                        </div>
                    </div>
                    <div class="border border-dashed bg-transparent-light rounded p-2 mb-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="d-block border border-2 h-12 border-info rounded-5 me-2"></span>
                                <div>
                                    <h6 class="fw-medium mb-1">Wordpress</h6>
                                    <p>Updated : 15 May 2025</p>
                                </div>
                            </div>
                            <div class="circle-progress circle-progress-md" data-value='61'>
                                <span class="progress-left"><span class="progress-bar border-info"></span></span>
                                <span class="progress-right"><span class="progress-bar border-info"></span></span>
                                <div class="progress-value">61%</div>
                            </div>
                        </div>
                    </div>
                    <div class="border border-dashed bg-transparent-light rounded p-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="d-block border border-2 h-12 border-dark rounded-5 me-2"></span>
                                <div>
                                    <h6 class="fw-medium mb-1">Javascript</h6>
                                    <p>Updated : 13 May 2025</p>
                                </div>
                            </div>
                            <div class="circle-progress circle-progress-md" data-value='58'>
                                <span class="progress-left"><span class="progress-bar border-dark"></span></span>
                                <span class="progress-right"><span class="progress-bar border-dark"></span></span>
                                <div class="progress-value">58%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /My Skills Card -->

    <!-- Team Birthday + Leave Policy + Next Holiday (Stacked in one column) -->
    <div class="col-xl-4 d-flex">
        <div class="flex-fill w-100">
            <div class="card card-bg-5 bg-dark mb-3">
                <div class="card-body">
                    <div class="text-center">
                        <h5 class="text-white mb-4">Team Birthday</h5>
                        <span class="avatar avatar-xl avatar-rounded mb-2">
                            <img src="assets/img/users/user-35.jpg" alt="Img">
                        </span>
                        <div class="mb-3">
                            <h6 class="text-white fw-medium mb-1">Andrew Jermia</h6>
                            <p>IOS Developer</p>
                        </div>
                        <a href="#" class="btn btn-sm btn-primary">Send Wishes</a>
                    </div>
                </div>
            </div>
            <div class="card bg-secondary mb-3">
                <div class="card-body d-flex align-items-center justify-content-between p-3">
                    <div>
                        <h5 class="text-white mb-1">Leave Policy</h5>
                        <p class="text-white">Last Updated : Today</p>
                    </div>
                    <a href="#" class="btn btn-white btn-sm px-3">View All</a>
                </div>
            </div>
            <div class="card bg-warning">
                <div class="card-body d-flex align-items-center justify-content-between p-3">
                    <div>
                        <h5 class="mb-1">Next Holiday</h5>
                        <p class="text-gray-9">Diwali, 15 Sep 2025</p>
                    </div>
                    <a href="holidays.html" class="btn btn-white btn-sm px-3">View All</a>
                </div>
            </div>
        </div>
    </div>
    <!-- /Team Birthday + Leave Policy + Next Holiday -->
</div>
<!-- End of Horizontal Row -->

<!-- Row 2: Meetings Schedule (Full Width Below) -->
<div class="row mt-4">
    <div class="col-xl-12 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                    <h5>Meetings Schedule</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>Today
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">Today</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">This Month</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">This Year</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body schedule-timeline">
                <div class="d-flex align-items-start">
                    <div class="d-flex align-items-center active-time">
                        <span>09:25 AM</span>
                        <span><i class="ti ti-point-filled text-primary fs-20"></i></span>
                    </div>
                    <div class="flex-fill ps-3 pb-4 timeline-flow">
                        <div class="bg-light p-2 rounded">
                            <p class="fw-medium text-gray-9 mb-1">Marketing Strategy Presentation</p>
                            <span>Marketing</span>
                        </div>
                    </div>
                </div>
                <div class="d-flex align-items-start">
                    <div class="d-flex align-items-center active-time">
                        <span>09:20 AM</span>
                        <span><i class="ti ti-point-filled text-secondary fs-20"></i></span>
                    </div>
                    <div class="flex-fill ps-3 pb-4 timeline-flow">
                        <div class="bg-light p-2 rounded">
                            <p class="fw-medium text-gray-9 mb-1">Design Review Hospital, doctors Management Project</p>
                            <span>Review</span>
                        </div>
                    </div>
                </div>
                <div class="d-flex align-items-start">
                    <div class="d-flex align-items-center active-time">
                        <span>09:18 AM</span>
                        <span><i class="ti ti-point-filled text-warning fs-20"></i></span>
                    </div>
                    <div class="flex-fill ps-3 pb-4 timeline-flow">
                        <div class="bg-light p-2 rounded">
                            <p class="fw-medium text-gray-9 mb-1">Birthday Celebration of Employee</p>
                            <span>Celebration</span>
                        </div>
                    </div>
                </div>
                <div class="d-flex align-items-start">
                    <div class="d-flex align-items-center active-time">
                        <span>09:10 AM</span>
                        <span><i class="ti ti-point-filled text-success fs-20"></i></span>
                    </div>
                    <div class="flex-fill ps-3 timeline-flow">
                        <div class="bg-light p-2 rounded">
                            <p class="fw-medium text-gray-9 mb-1">Update of Project Flow</p>
                            <span>Development</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- End of Meetings Schedule Row -->
        <!-- First Row: Performance | My Skills | Birthday/Policy/Holiday -->
<div class="row mb-4">
    <!-- Performance Card -->
    <div class="col-xl-4 col-lg-6 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    <h5>Performance</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>2024
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="bg-light d-flex align-items-center rounded p-2 mb-3">
                    <h3 class="me-2">98%</h3>
                    <span class="badge badge-outline-success bg-success-transparent rounded-pill me-1">12%</span>
                    <span>vs last years</span>
                </div>
                <div id="performance_chart2"></div>
            </div>
        </div>
    </div>

    <!-- My Skills Card -->
    <div class="col-xl-4 col-lg-6 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    <h5>My Skills</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>2024
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <!-- Skills list (same as before) -->
                <div class="border border-dashed bg-transparent-light rounded p-2 mb-2">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                            <span class="d-block border border-2 h-12 border-primary rounded-5 me-2"></span>
                            <div>
                                <h6 class="fw-medium mb-1">Figma</h6>
                                <p>Updated : 15 May 2025</p>
                            </div>
                        </div>
                        <div class="circle-progress circle-progress-md" data-value='95'>
                            <span class="progress-left"><span class="progress-bar border-primary"></span></span>
                            <span class="progress-right"><span class="progress-bar border-primary"></span></span>
                            <div class="progress-value">95%</div>
                        </div>
                    </div>
                </div>
                <!-- Repeat other skills similarly -->
                <!-- (HTML, CSS, Wordpress, Javascript - omitted for brevity but keep them) -->
            </div>
        </div>
    </div>

    <!-- Birthday + Leave Policy + Next Holiday (stacked) -->
    <div class="col-xl-4 d-flex">
        <div class="flex-fill w-100">
            <div class="card card-bg-5 bg-dark mb-3">
                <div class="card-body text-center">
                    <h5 class="text-white mb-4">Team Birthday</h5>
                    <span class="avatar avatar-xl avatar-rounded mb-2">
                        <img src="assets/img/users/user-35.jpg" alt="Img">
                    </span>
                    <div class="mb-3">
                        <h6 class="text-white fw-medium mb-1">Andrew Jermia</h6>
                        <p>IOS Developer</p>
                    </div>
                    <a href="#" class="btn btn-sm btn-primary">Send Wishes</a>
                </div>
            </div>
            <div class="card bg-secondary mb-3">
                <div class="card-body d-flex align-items-center justify-content-between p-3">
                    <div>
                        <h5 class="text-white mb-1">Leave Policy</h5>
                        <p class="text-white">Last Updated : Today</p>
                    </div>
                    <a href="#" class="btn btn-white btn-sm px-3">View All</a>
                </div>
            </div>
            <div class="card bg-warning">
                <div class="card-body d-flex align-items-center justify-content-between p-3">
                    <div>
                        <h5 class="mb-1">Next Holiday</h5>
                        <p class="text-gray-9">Diwali, 15 Sep 2025</p>
                    </div>
                    <a href="holidays.html" class="btn btn-white btn-sm px-3">View All</a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- End First Row -->

<!-- Second Row: Team Members | Notifications | Meetings Schedule -->
<div class="row">
    <!-- Team Members Card -->
    <div class="col-xl-4 col-lg-6 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    <h5>Team Members</h5>
                    <a href="#" class="btn btn-light btn-sm">View All</a>
                </div>
            </div>
            <div class="card-body">
                <!-- Team member list (repeat as needed) -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div class="d-flex align-items-center">
                        <a href="javascript:void(0);" class="avatar flex-shrink-0">
                            <img src="assets/img/users/user-27.jpg" class="rounded-circle border border-2" alt="img">
                        </a>
                        <div class="ms-2">
                            <h6 class="fs-14 fw-medium text-truncate mb-1"><a href="#">Alexander Jermai</a></h6>
                            <p class="fs-13">UI/UX Designer</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <a href="#" class="btn btn-light btn-icon btn-sm me-2"><i class="ti ti-phone fs-16"></i></a>
                        <a href="#" class="btn btn-light btn-icon btn-sm me-2"><i class="ti ti-mail-bolt fs-16"></i></a>
                        <a href="#" class="btn btn-light btn-icon btn-sm"><i class="ti ti-brand-hipchat fs-16"></i></a>
                    </div>
                </div>
                <!-- More team members... (keep the rest from original) -->
            </div>
        </div>
    </div>

    <!-- Notifications Card -->
    <div class="col-xl-4 col-lg-6 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    <h5>Notifications</h5>
                    <a href="#" class="btn btn-light btn-sm">View All</a>
                </div>
            </div>
            <div class="card-body">
                <!-- Notification items -->
                <div class="d-flex align-items-start mb-4">
                    <a href="javascript:void(0);" class="avatar flex-shrink-0">
                        <img src="assets/img/users/user-27.jpg" class="rounded-circle border border-2" alt="img">
                    </a>
                    <div class="ms-2">
                        <h6 class="fs-14 fw-medium text-truncate mb-1">Lex Murphy requested access to UNIX</h6>
                        <p class="fs-13 mb-2">Today at 9:42 AM</p>
                        <div class="d-flex align-items-center">
                            <a href="#" class="avatar avatar-sm border flex-shrink-0 me-2">
                                <img src="assets/img/social/pdf-icon.svg" class="w-auto h-auto" alt="Img">
                            </a>
                            <h6 class="fw-normal"><a href="#">EY_review.pdf</a></h6>
                        </div>
                    </div>
                </div>
                <!-- More notifications... (keep original ones) -->
            </div>
        </div>
    </div>

    <!-- Meetings Schedule Card -->
    <div class="col-xl-4 col-lg-12 d-flex">
        <div class="card flex-fill">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    <h5>Meetings Schedule</h5>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class="btn btn-white border btn-sm d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            <i class="ti ti-calendar me-1"></i>Today
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end p-3">
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">Today</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">This Month</a></li>
                            <li><a href="javascript:void(0);" class="dropdown-item rounded-1">This Year</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body schedule-timeline">
                <div class="d-flex align-items-start">
                    <div class="d-flex align-items-center active-time">
                        <span>09:25 AM</span>
                        <span><i class="ti ti-point-filled text-primary fs-20"></i></span>
                    </div>
                    <div class="flex-fill ps-3 pb-4 timeline-flow">
                        <div class="bg-light p-2 rounded">
                            <p class="fw-medium text-gray-9 mb-1">Marketing Strategy Presentation</p>
                            <span>Marketing</span>
                        </div>
                    </div>
                </div>
                <!-- More meetings... (keep the rest) -->
            </div>
        </div>
    </div>
</div>
<!-- End Second Row -->
    </div>
</asp:Content>