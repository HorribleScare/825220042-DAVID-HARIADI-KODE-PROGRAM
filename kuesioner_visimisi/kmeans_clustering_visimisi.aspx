<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="KMeansClusteringVisiMisi"
Src="../ascx/kuesioner_visimisi/kmeans_clustering_visimisi.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  K-Means Clustering Kuesioner Visi Misi | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control KMeansClusteringVisiMisi dengan ID KMeansClusteringVisiMisi1 untuk menampilkan konten utama -->
  <uc:KMeansClusteringVisiMisi
    ID="KMeansClusteringVisiMisi1"
    runat="server"
  />
</asp:Content>
