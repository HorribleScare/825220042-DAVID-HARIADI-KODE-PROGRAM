<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="KPIDashboard"
Src="../ascx/kuesioner_kpi/kpi_dashboard.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard KPI | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <uc:KPIDashboard ID="KPIDashboard1" runat="server" />
</asp:Content>
