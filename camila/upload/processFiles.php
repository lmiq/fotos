<center>
<?
$uploadNeed = $_POST['uploadNeed'];
// start for loop
for($x=0;$x<$uploadNeed;$x++){
$file_name = $_FILES['uploadFile'. $x]['name'];
if($file_name > " "){
// strip file_name of slashes
$file_name = stripslashes($file_name);
$file_name = str_replace("'","",$file_name);
$copy = copy($_FILES['uploadFile'. $x]['tmp_name'],$file_name);
 // check if successfully copied
 if($copy){
 echo "<b>$file_name &nbsp; uploaded sucessfully!</b><br>";
 }else{
 echo "$file_name | could not be uploaded!<br>";
 }
}
} // end of loop
?>
</center>
