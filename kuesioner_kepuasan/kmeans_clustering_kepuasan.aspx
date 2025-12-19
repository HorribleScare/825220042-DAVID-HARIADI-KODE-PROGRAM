<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="KMeansClusteringKepuasan"
Src="../ascx/kuesioner_kepuasan/kmeans_clustering_kepuasan.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  K-Means Clustering Kuesioner Kepuasan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control KMeansClusteringKepuasan dengan ID KMeansClusteringKepuasan1 untuk menampilkan konten utama -->
  <uc:KMeansClusteringKepuasan
    ID="KMeansClusteringKepuasan1"
    runat="server"
  />
</asp:Content>
