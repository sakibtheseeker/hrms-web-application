<%@ Page Title="Tasks"
    Language="C#"
    MasterPageFile="~/AdminMaster.Master"
    AutoEventWireup="true"
    CodeBehind="TaskList.aspx.cs"
    Inherits="hrms_web_application.TaskList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />

<style>
    .todo-tabs .nav-link {
        border: none;
        padding: 0.5rem 1rem;
        color: #6c757d;
    }
    .todo-tabs .nav-link.active {
        background-color: #0d6efd;
        color: white;
        border-radius: 0.25rem;
    }
    .badge-skyblue {
        background-color: #e7f5ff;
        color: #1c7ed6;
    }
    .progress-xs {
        height: 0.25rem;
    }
    .rating-select .filled {
        color: #ffc107;
    }
    .list-item-hover:hover {
        background-color: #f8f9fa;
    }
</style>

<!-- Page Header -->
<div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
    <div class="my-auto mb-2">
        <h2 class="mb-1">Tasks</h2>
    </div>
    <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
        <div class="mb-2">
            <a href="AddTask.aspx" class="btn btn-primary d-flex align-items-center">
                <i class="ti ti-circle-plus me-2"></i>Add Task
            </a>
        </div>
    </div>
</div>

<div class="container-fluid">

<div class="row">
<div class="col-xl-8">
    <div class="row">
        <div class="col-lg-5">
            <div class="d-flex align-items-center flex-wrap row-gap-3 mb-3">
                <h6 class="me-2">Priority</h6>

                <ul class="nav nav-pills border d-inline-flex p-1 rounded bg-light todo-tabs">
                    <li class="nav-item">
                        <asp:LinkButton ID="btnAll" runat="server"
                            CssClass="nav-link active"
                            OnClick="FilterByPriority"
                            CommandArgument="All">All</asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnHigh" runat="server"
                            CssClass="nav-link"
                            OnClick="FilterByPriority"
                            CommandArgument="High">High</asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnMedium" runat="server"
                            CssClass="nav-link"
                            OnClick="FilterByPriority"
                            CommandArgument="Medium">Medium</asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnLow" runat="server"
                            CssClass="nav-link"
                            OnClick="FilterByPriority"
                            CommandArgument="Low">Low</asp:LinkButton>
                    </li>
                </ul>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="d-flex align-items-center justify-content-lg-end mb-3">
                <asp:TextBox ID="txtDueDateFilter" runat="server"
                    CssClass="form-control w-25"
                    TextMode="Date"
                    AutoPostBack="true"
                    OnTextChanged="FilterByDate" />
            </div>
        </div>
    </div>
</div>
</div>

<div class="row">

<!-- LEFT: PROJECTS -->
<div class="col-xl-4" style="height: 100vh; overflow-y: auto;">
<asp:UpdatePanel ID="UpdatePanelProjects" runat="server" UpdateMode="Conditional">
<ContentTemplate>

<asp:Repeater ID="rptProjects" runat="server">
<ItemTemplate>

<div class="card mb-3">
<div class="card-body">

<div class="d-flex align-items-center pb-3 mb-3 border-bottom">
    <img src='<%# ResolveUrl("~/" + Eval("LogoPath").ToString().Replace("wwwroot/", "")) %>'
         style="width:50px;height:50px;object-fit:cover;" />
    <div class="ms-2">
        <h6 class="mb-1"><%# Eval("ProjectName") %></h6>
        <small><%# Eval("TotalTasks") %> Tasks • <%# Eval("CompletedTasks") %> Done</small>
    </div>
</div>

<p><strong>Deadline:</strong>
    <%# Convert.ToDateTime(Eval("Deadline")).ToString("dd MMM yyyy") %>
</p>

<div class="progress progress-xs">
    <div class="progress-bar bg-info"
         style='width:<%# Eval("Percentage") %>%'></div>
</div>

</div>
</div>

</ItemTemplate>
</asp:Repeater>

</ContentTemplate>
<Triggers>
    <asp:AsyncPostBackTrigger ControlID="btnAll" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnHigh" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnMedium" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnLow" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="txtDueDateFilter" EventName="TextChanged" />
</Triggers>
</asp:UpdatePanel>
</div>

<!-- RIGHT: TASK DETAILS -->
<div class="col-xl-8" style="height: 100vh; overflow-y: auto;">
<asp:UpdatePanel ID="UpdatePanelTasks" runat="server" UpdateMode="Conditional">
<ContentTemplate>

<asp:Repeater ID="rptTaskDetails" runat="server">
<ItemTemplate>

<div class="card mb-3">
<div class="card-body">
<h5><%# Eval("ProjectName") %></h5>

<div class="progress progress-xs mb-2">
    <div class="progress-bar bg-info"
         style='width:<%# Eval("CompletionPercentage") %>%'></div>
</div>

<p><%# Eval("CompletionPercentage") %>% completed</p>

</div>
</div>

</ItemTemplate>
</asp:Repeater>

</ContentTemplate>
<Triggers>
    <asp:AsyncPostBackTrigger ControlID="btnAll" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnHigh" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnMedium" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="btnLow" EventName="Click" />
    <asp:AsyncPostBackTrigger ControlID="txtDueDateFilter" EventName="TextChanged" />
</Triggers>
</asp:UpdatePanel>
</div>

</div>
</div>

</asp:Content>
