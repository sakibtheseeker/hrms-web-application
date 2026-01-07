<%@ Page Title="Events Calendar" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AddEvent.aspx.cs" Inherits="hrms_web_application.AddEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Page Header -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Events Calendar</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">Event</li>
                    <li class="breadcrumb-item active" aria-current="page">Calendar</li>
                </ol>
            </nav>
        </div>
    </div>
    <!-- /Page Header -->

    <div class="row">
        <!-- Calendar Section -->
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    
                    <!-- Calendar Navigation -->
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
                    <!-- /Calendar Navigation -->

                    <!-- Calendar Grid -->
                    <div class="table-responsive">
                        <asp:Calendar ID="EventCalendar" runat="server" 
                            CssClass="table table-bordered calendar-table" 
                            OnDayRender="EventCalendar_DayRender"
                            OnSelectionChanged="EventCalendar_SelectionChanged"
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
                            <SelectedDayStyle BackColor="#007bff" ForeColor="White" />
                        </asp:Calendar>
                    </div>
                    <!-- /Calendar Grid -->

                </div>
            </div>
        </div>
        <!-- /Calendar Section -->

        <!-- Right Sidebar - Add Event & Event List -->
        <div class="col-lg-4">
            
            <!-- Add New Event Button -->
            <div class="card mb-3">
                <div class="card-body text-center">
                    <button type="button" class="btn btn-primary btn-lg w-100" data-bs-toggle="modal" data-bs-target="#eventModal" onclick="clearEventForm();">
                        Add New Event
                    </button>
                </div>
            </div>
            <!-- /Add New Event Button -->

            <!-- Upcoming Events List -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Upcoming Events</h5>
                </div>
                <div class="card-body" style="max-height: 500px; overflow-y: auto;">
                    <asp:Repeater ID="rptUpcomingEvents" runat="server">
                        <ItemTemplate>
                            <div class="event-item mb-3 p-3 border rounded">
                                <h6 class="mb-1"><%# Eval("Title") %></h6>
                                <p class="text-primary mb-2">
                                    <i class="ti ti-calendar me-1"></i>
                                    <%# Eval("Date") %>
                                </p>
                                <span class="badge" style='background-color: <%# Eval("Color") %>'>
                                    <%# Eval("EventTypeName") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Label ID="lblNoEvents" runat="server" 
                        Text="No upcoming events" 
                        CssClass="text-muted" 
                        Visible="false">
                    </asp:Label>
                </div>
            </div>
            <!-- /Upcoming Events List -->

        </div>
        <!-- /Right Sidebar -->
    </div>

    <!-- Add/Edit Event Modal - VALIDATION MESSAGES REMOVED -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Event</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Hidden Field for Event ID -->
                    <asp:HiddenField ID="hfEventId" runat="server" Value="0" />
                    
                    <!-- Event Title -->
                    <div class="mb-3">
                        <label class="form-label">Event Title <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" 
                            placeholder="Enter event title" MaxLength="200"></asp:TextBox>
                    </div>
                    
                    <!-- Event Date -->
                    <div class="mb-3">
                        <label class="form-label">Event Date <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" 
                            TextMode="Date"></asp:TextBox>
                    </div>

                    <!-- Event Type -->
                    <div class="mb-3">
                        <label class="form-label">Event Type <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlEventType" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <!-- Status (Hidden - Always Active) -->
                    <asp:HiddenField ID="hfStatus" runat="server" Value="Active" />

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveEvent" runat="server" Text="Add Event" 
                        CssClass="btn btn-primary" 
                        OnClick="btnSaveEvent_Click" />
                </div>
            </div>
        </div>
    </div>
    <!-- /Add/Edit Event Modal -->

    <!-- Custom CSS for Calendar -->
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
            cursor: pointer;
        }
        
        .calendar-day:hover {
            background-color: #f8f9fa !important;
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
            padding: 3px 6px;
            border-radius: 3px;
            font-size: 10px;
            color: white;
            margin-top: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
        }
        
        .event-badge:hover {
            opacity: 0.8;
        }
        
        .event-item {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .event-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
    </style>

    <!-- JavaScript -->
    <script type="text/javascript">
        // Modal clear karne ka function
        function clearEventForm() {
            document.getElementById('<%= txtTitle.ClientID %>').value = '';
            document.getElementById('<%= txtDate.ClientID %>').value = '';
            document.getElementById('<%= ddlEventType.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= hfEventId.ClientID %>').value = '0';
        }

        // Page load hone par selected date set karna
        function setSelectedDate(date) {
            document.getElementById('<%= txtDate.ClientID %>').value = date;
            var modal = new bootstrap.Modal(document.getElementById('eventModal'));
            modal.show();
        }
    </script>

</asp:Content>