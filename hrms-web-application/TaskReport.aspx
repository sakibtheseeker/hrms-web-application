<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="TaskReport.aspx.cs" Inherits="$safeprojectname$.TaskReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
            <div class="content">
<div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
    <div class="my-auto mb-2">
        <h2 class="mb-1">Task Report</h2>
        <nav>
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="index.html"><i class="ti ti-smart-home"></i></a>
                </li>
                <li class="breadcrumb-item">
                    HR
                </li>
                <li class="breadcrumb-item active" aria-current="page">Task Report</li>
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
                        <a class="dropdown-item rounded-1" href="/ProjectTaskReport/TaskExportToPDF"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a>
                    </li>
                    <li>
                        <a class="dropdown-item rounded-1" href="/ProjectTaskReport/TaskExportToExcel"><i class="ti ti-file-type-xls me-1"></i>Export as Excel </a>
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

<div class="row">

    <!-- Total Exponses -->
    <div class="col-lg-6 col-md-6 d-flex">
        <div class="row flex-fill">
            <div class="col-lg-6 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body ">
                        <div class="row align-items-center">
                            <div class="col-8">
                                <div>
                                    <span class="fs-14 fw-normal text-truncate mb-1">Total Tasks</span>
<h5>
            <asp:Label ID="lblTotalTasks" runat="server" Text="0"></asp:Label>
        </h5>                                </div>
                            </div>
                            <div class="col-4">
                                <p class="data-attributes">
                                    <span class="peity-chart" data-peity='{ "fill": ["#F26522", "rgba(67, 87, 133, .09)"], "innerRadius": 16, "radius": 32 }'>100%</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body ">
                        <div class="row align-items-center">
                            <div class="col-8">
                                <div>
                                    <span class="fs-14 fw-normal text-truncate mb-1">Completed Tasks</span>
                                   <h5>
        <asp:Label ID="lblCompletedTasks" runat="server" Text="0"></asp:Label>
    </h5>
                                </div>
                            </div>
                            <div class="col-4">
                                <p class="data-attributes">
                                    <span class="peity-chart" data-peity='{ "fill": ["#03C95A", "rgba(67, 87, 133, .09)"], "innerRadius": 16, "radius": 32 }'>11/100</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-8">
                                <div>
                                    <span class="fs-14 fw-normal text-truncate mb-1">OnHold Tasks</span>
<h5>
        <asp:Label ID="lblOnHoldTasks" runat="server" Text="0"></asp:Label>
    </h5>                                </div>
                            </div>
                            <div class="col-4">
                                <p class="data-attributes">
                                    <span class="peity-chart" data-peity='{ "fill": ["#F26522", "rgba(67, 87, 133, .09)"], "innerRadius": 16, "radius": 32 }'>33/100</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-6 d-flex">
                <div class="card flex-fill">
                    <div class="card-body ">
                        <div class="row align-items-center">
                            <div class="col-8">
                                <div>
                                    <span class="fs-14 fw-normal text-truncate mb-1">Overdue Tasks</span>
<h5>
        <asp:Label ID="lblOverdueTasks" runat="server" Text="0"></asp:Label>
    </h5>                                </div>
                            </div>
                            <div class="col-4">
                                <p class="data-attributes">
                                    <span class="peity-chart" data-peity='{ "fill": ["#03C95A", "rgba(67, 87, 133, .09)"], "innerRadius": 16, "radius": 32 }'>33/100</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    <!-- /Total Exponses -->
    <!-- Total Exponses -->
    <div class="col-lg-6 col-md-6 d-flex">
        <div class="card flex-fill">
            <div class="card-header border-0">
                <div class="d-flex flex-wrap justify-content-between align-items-center">
                    <div class="d-flex align-items-center ">
                        <span class="me-2"><i class="ti ti-chart-pie text-danger"></i></span>
                        <h5>Tasks</h5>
                    </div>
                    <div class="dropdown">
                        <a href="javascript:void(0);" class=" btn btn-sm fs-12 btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                            Task Data
                        </a>
                    </div>
                </div>
            </div>
                        <div class="card-body pt-0">
                <div class="row align-items-center">
                    <div class="col-md-6 d-flex align-items-center justify-content-center">
                        <div class="position-relative payment-total">
                            <div id="task-reports"></div>
                            <div class="task-total-content ">
                                <p class="fs-16 fw-normal mb-0">Pending</p>
                                <span class="display-3 fs-24 fw-bold text-skyblue">30%</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row gy-4">
                            <div class="col-md-6">
                                <div class="d-flex task-report-icons">
                                    <span class="me-2"><i class="ti ti-arrow-badge-right-filled text-success"></i></span>
                                    <h6 class="fs-16">Completed <span class="fs-14 fw-normal">40%</span></h6>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex task-report-icons">
                                    <span class="me-2"><i class="ti ti-arrow-badge-right-filled text-skyblue"></i></span>
                                    <h6 class="fs-16">Pending <span class="fs-14 fw-normal">30 %</span></h6>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex task-report-icons">
                                    <span class="me-2"><i class="ti ti-arrow-badge-right-filled text-warning"></i></span>
                                    <h6 class="fs-16">Inprogress  <span class="fs-14 fw-normal">20 %</span></h6>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex task-report-icons">
                                    <span class="me-2"><i class="ti ti-arrow-badge-right-filled text-purple"></i></span>
                                    <h6 class="fs-16">On Hold <span class="fs-14 fw-normal">10 %</span></h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /Total Exponses -->
</div>
<div class="card mt-4">

    <!-- CARD HEADER -->
    <div class="card-header">

        <!-- ROW 1 : TITLE + FILTERS -->
        <div class="row align-items-center">
            <div class="col-md-4">
                <h5 class="mb-0">Tasks List</h5>
            </div>

            <div class="col-md-8">
                <div class="d-flex justify-content-end gap-2 flex-wrap">
                   <asp:DropDownList
    ID="ddlPrioritySort"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlPrioritySort_SelectedIndexChanged">

    <asp:ListItem Value="">Priority</asp:ListItem>
    <asp:ListItem Value="Low">Low</asp:ListItem>
    <asp:ListItem Value="Medium">Medium</asp:ListItem>
    <asp:ListItem Value="High">High</asp:ListItem>

</asp:DropDownList>


                    <asp:DropDownList
    ID="ddlStatusFilter"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">

    <asp:ListItem Text="Status" Value="" />
    <asp:ListItem Text="Completed" Value="Completed" />
    <asp:ListItem Text="Pending" Value="Pending" />
    <asp:ListItem Text="Inprogress" Value="Inprogress" />
    <asp:ListItem Text="On Hold" Value="On Hold" />

</asp:DropDownList>


                    <asp:DropDownList
    ID="ddlSortBy"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">

    <asp:ListItem Text="Sort By" Value="" />
    <asp:ListItem Text="Recently Added" Value="recent" />
    <asp:ListItem Text="Ascending" Value="asc" />
    <asp:ListItem Text="Descending" Value="desc" />

</asp:DropDownList>

                </div>
            </div>
        </div>

        <!-- ROW 2 : SEARCH -->
        <div class="row mt-3">
    <div class="col-md-4 ms-auto">
        <asp:TextBox
            ID="txtSearch"
            runat="server"
            CssClass="form-control"
            Placeholder="Search tasks..."
            AutoPostBack="true"
            OnTextChanged="txtSearch_TextChanged" />
    </div>
</div>

        </div>

    </div>

    <!-- CARD BODY -->
    <div class="card-body p-0">
        <div class="table-responsive">

            <asp:GridView
                ID="gvTaskTable"
                runat="server"
                CssClass="table table-striped table-hover mb-0"
                AutoGenerateColumns="False"
                GridLines="None"
                EmptyDataText="No tasks found">

                <HeaderStyle CssClass="table-light" />

                <Columns>
                    <asp:BoundField DataField="TaskId" HeaderText="Task ID" />
                    <asp:BoundField DataField="TaskName" HeaderText="Task Name" />
                    <asp:BoundField DataField="ProjectName" HeaderText="Project Name" />
                    <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />

                    <asp:TemplateField HeaderText="Priority">
                        <ItemTemplate>
                            <span class='<%# GetPriorityBadge(Eval("Priority").ToString()) %>'>
                                <i class="ti ti-point-filled me-1"></i>
                                <%# Eval("Priority") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# GetStatusBadge(Eval("Status").ToString()) %>'>
                                <i class="ti ti-point-filled me-1"></i>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

            </asp:GridView>

        </div>
    </div>

</div>
</asp:Content>
