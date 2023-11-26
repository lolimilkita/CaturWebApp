<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CaturWebApp.Index" %>

<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tasks Homepage</title>
 
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    <script type="text/javascript">
        function openTaskDetail() {
            //alert("Opening modal!");
            $('#modTaskDetail').modal('show');
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="container">
 
            <%-- Webpage Heading --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Tasks Homepage</h1>
                </div>
            </div>
 
            <%-- Menu / Message / New link --%>
            <div class="navbar-collapse collapse">
                <div class="col-sm-4">
                    <ul class="nav navbar-nav" style="font-weight: bold;">
                        <li>
                            <asp:HyperLink ID="hlHome" NavigateUrl="~/Index.aspx" runat="server">Home</asp:HyperLink><br />
                        </li>
                    </ul>
                </div>
                <div class="col-sm-4">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <div class="col-sm-4" style="text-align: right;">
                    <asp:Label ID="Label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>
                    <asp:LinkButton ID="lbNewTasks" runat="server" Font-Size="12px" OnClick="lbNewTasks_Click">New</asp:LinkButton>
                    <asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>
                </div>
                <div id="search">         
                    <asp:TextBox ID="txtSearchMaster" runat="server"></asp:TextBox>
                    <asp:DropDownList ID="DropDownList1" runat="server">
                        <asp:ListItem Enabled="true" Text="Select Status" Value=""></asp:ListItem>
                        <asp:ListItem Text="Pending" Value="1"></asp:ListItem>
                        <asp:ListItem Text="In Progress" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Completed" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                </div>
            </div>
 
            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvTasks" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="ID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvTasks_RowDeleting"
                        OnRowCommand="gvTasks_RowCommand"
                        EmptyDataText="No data for this request!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="title" HeaderText="Title">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="description" HeaderText="Descriptions">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="status" HeaderText="Status">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="created_at" HeaderText="Created At">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="updated_at" HeaderText="Updated At">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <%-- Delete Task --%>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelTask" Text="Del" runat="server"
                                        OnClientClick="return confirm('Are you sure you want to delete this task?');" CommandName="Delete" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                            </asp:TemplateField>
 
                            <%-- Update Task --%>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbUpdTask" runat="server" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="UpdTask" Text="Upd" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                            </asp:TemplateField>
 
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
 
        </div>
 
        <!-- Modal to Add New or View / Update a Tasks Details-->
        <div class="modal fade" id="modTaskDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">
         
                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblTaskNew" runat="server" Text="Add New Task" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblTaskUpd" runat="server" Text="View / Update an Task" Font-Size="24px" Font-Bold="true" />
                    </div>
         
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">
         
                                <%-- Task Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtTaskTitle" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Task Title"
                                                AutoCompleteType="Disabled" placeholder="Task Title" />
                                            <asp:Label runat="server" ID="lblTaskID" Visible="false" Font-Size="12px" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" CssClass="form-control input-xs" 
                                                ToolTip="Description"
                                                AutoCompleteType="Disabled" placeholder="Description" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control input-xs" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
         
                        <%-- Message label on modal page --%>
                        <div class="row" style="margin-top: 20px; margin-bottom: 10px;">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-10">
                                <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>
         
                    <%-- Add, Update and Cancel Buttons --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddTask" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Add Task"
                            Visible="true" CausesValidation="false"
                            OnClick="btnAddTask_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnUpdTask" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Update Task"
                            Visible="false" CausesValidation="false"
                            OnClick="btnUpdTask_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnClose" runat="server" class="btn btn-info button-xs" data-dismiss="modal" Text="Close" 
                            CausesValidation="false"
                            UseSubmitBehavior="false" />
                    </div>
         
                </div>
            </div>
        </div>

    </form>
</body>
</html>
