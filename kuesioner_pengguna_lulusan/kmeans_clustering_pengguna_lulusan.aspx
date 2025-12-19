<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="KMeansClusteringPenggunaLulusan"
Src="../ascx/kuesioner_pengguna_lulusan/kmeans_clustering_pengguna_lulusan.ascx"
%>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  K-Means Clustering Kuesioner Pengguna Lulusan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control KMeansClusteringPenggunaLulusan dengan ID KMeansClusteringPenggunaLulusan1 untuk menampilkan konten utama -->
  <uc:KMeansClusteringPenggunaLulusan
    ID="KMeansClusteringPenggunaLulusan1"
    runat="server"
  />
</asp:Content>
