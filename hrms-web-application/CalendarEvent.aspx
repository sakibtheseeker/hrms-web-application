<%@ Page Title="Events Calendar" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="CalendarEvent.aspx.cs" Inherits="hrms_web_application.CalendarEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Events Calendar</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">Calendar</li>
                    <li class="breadcrumb-item active">Events</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row">
        
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div class="d-flex align-items-center">
                            <asp:LinkButton ID="btnPrevMonth" runat="server" CssClass="btn btn-dark btn-icon me-2" OnClick="btnPrevMonth_Click" CausesValidation="false">
                                <i class="ti ti-chevron-left"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnNextMonth" runat="server" CssClass="btn btn-dark btn-icon me-2" OnClick="btnNextMonth_Click" CausesValidation="false">
                                <i class="ti ti-chevron-right"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnToday" runat="server" CssClass="btn btn-dark" OnClick="btnToday_Click" CausesValidation="false">
                                today
                            </asp:LinkButton>
                        </div>
                        
                        <h4 class="mb-0">
                            <asp:Label ID="lblCurrentMonth" runat="server"></asp:Label>
                        </h4>
                        
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-dark active">month</button>
                            <button type="button" class="btn btn-outline-dark">week</button>
                            <button type="button" class="btn btn-outline-dark">day</button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <asp:Calendar ID="EventCalendar" runat="server" 
                            CssClass="table table-bordered calendar-table" 
                            OnDayRender="EventCalendar_DayRender"
                            FirstDayOfWeek="Sunday"
                            ShowGridLines="True"
                            Width="100%"
                            CellPadding="10"
                            CellSpacing="0">
                            <DayHeaderStyle CssClass="calendar-header" BackColor="#343a40" ForeColor="White" Font-Bold="True" Height="40px" />
                            <TitleStyle CssClass="d-none" />
                            <DayStyle CssClass="calendar-day" Height="100px" VerticalAlign="Top" />
                            <TodayDayStyle CssClass="calendar-today" BackColor="#fff9e6" />
                            <OtherMonthDayStyle CssClass="calendar-other-month" ForeColor="#999999" />
                        </asp:Calendar>
                    </div>

                </div>
            </div>
        </div>

        <div class="col-lg-4">
            
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Upcoming Events</h5>
                </div>
                <div class="card-body" style="max-height: 600px; overflow-y: auto;">
                    <asp:Repeater ID="rptUpcomingEvents" runat="server">
                        <ItemTemplate>
                            <div class="event-item mb-3 p-3 border rounded">
                                <h6 class="mb-1"><%# Eval("Title") %></h6>
                                <p class="text-primary mb-2">
                                    <i class="ti ti-calendar me-1"></i>
                                    <%# Eval("FormattedDate") %>
                                </p>
                                <span class="badge" style='background-color: <%# Eval("Color") %>'>
                                    <%# Eval("EventTypeName") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Label ID="lblNoEvents" runat="server" 
                        Text="No upcoming events" 
                        CssClass="text-muted text-center d-block" 
                        Visible="false">
                    </asp:Label>
                </div>
            </div>

        </div>

    </div>

    <style>
        .calendar-table {
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .calendar-table td {
            border: 1px solid #dee2e6;
            padding: 8px;
            vertical-align: top;
            height: 100px;
            position: relative;
        }
        
        .calendar-header {
            background-color: #343a40 !important;
            color: white !important;
            font-weight: bold;
            text-align: center;
            padding: 10px;
        }
        
        .calendar-day {
            background-color: #ffffff;
        }
        
        .calendar-today {
            background-color: #fff9e6 !important;
        }
        
        .calendar-other-month {
            background-color: #f8f9fa;
            color: #999999;
        }
        
        .calendar-day a {
            color: #000;
            text-decoration: none;
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
        }
        
        .event-badge {
            display: block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 11px;
            color: white;
            margin-top: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .event-item {
            transition: all 0.3s ease;
            cursor: default;
        }
        
        .event-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
    </style>

</asp:Content>