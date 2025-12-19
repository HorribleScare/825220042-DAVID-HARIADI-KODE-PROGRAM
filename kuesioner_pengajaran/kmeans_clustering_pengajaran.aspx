<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="KMeansClusteringPengajaran"
Src="../ascx/kuesioner_pengajaran/kmeans_clustering_pengajaran.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  K-Means Clustering Kuesioner Pengajaran | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control KMeansClusteringPengajaran dengan ID KMeansClusteringPengajaran1 untuk menampilkan konten utama -->
  <uc:KMeansClusteringPengajaran
    ID="KMeansClusteringPengajaran1"
    runat="server"
  />
</asp:Content>
