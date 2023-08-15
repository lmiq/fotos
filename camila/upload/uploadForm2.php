<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<center>
<form name="form1" enctype="multipart/form-data" method="post"
action="processFiles.php">
  <p>
    <input type="submit" name="Submit" value="Upload"><br><br>
  <?
  // start of dynamic form
//  $uploadNeed = $_POST['uploadNeed'];
  $uploadNeed = 100;
  for($x=0;$x<$uploadNeed;$x++){
  ?>
    <input name="uploadFile<? echo $x;?>" type="file" id="uploadFile<?
echo $x;?>">
  </p>
  <?
  // end of for loop
  }
  ?>
  <p><input name="uploadNeed" type="hidden" value="<? echo
$uploadNeed;?>">
  </p>
</form>
</center?
</body>
</html>


