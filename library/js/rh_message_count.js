
window.onload = GetMessageCount;

function GetMessageCount()
{
  var xmlHttp

  try
  {
    //Firefox, Opera 8.0+, Safari
    xmlHttp = new XMLHttpRequest();
  }
  catch(e)
  {
    //Internet Explorer
    try
    {
      xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch(e)
    {
      try
      {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
      }
      catch(e)
      {
        alert("Your browser does not support AJAX!")
        return false;
      }
    }
  }

  xmlHttp.onreadystatechange = function()
  {
    if(xmlHttp.readyState == 4)
    {
      HandleResponse(xmlHttp.responseText);
    }
  }

  xmlHttp.open("GET", "rh_message_count.php", true);
  xmlHttp.send(null);
}

function HandleResponse(response)
{
  document.getElementById('rhmsgcount').innerHTML = response;
  setTimeout("GetMessageCount()",300000);  // 5 minutes
}
