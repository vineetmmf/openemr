function getXmlHttpRequestObject() {
	if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		return new ActiveXObject("Microsoft.XMLHTTP");
	} else {
		alert("Your Browser not support Ajax.");
	}
}

var searchReq = getXmlHttpRequestObject();

function searchSuggest(webroot) {
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = document.getElementById('diagnostic').value;

		if (frmSearch.method[0].checked) {
      var mStr = frmSearch.method[0].value;
    }else
    {
      var mStr = frmSearch.method[1].value;
    }
		var url = webroot + '/forms/body/autocomplete.php?search=' + str + '&m=' + mStr;
    if(str != "")
    {
		  searchReq.open("GET", url, true);
		  searchReq.onreadystatechange = handleSearchSuggest;
		  searchReq.send(null);
		}
	}
}

function handleSearchSuggest() {
	if (searchReq.readyState == 4) {
		var ss = document.getElementById('search_suggest')
		ss.innerHTML = '';
		var str = searchReq.responseText.split("\n");
		for(i=0; i < str.length - 1; i++) {
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setSearch(this.innerHTML);" ';
			suggest += 'class="suggest_link">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

function suggestOver(div_value) {
	div_value.className = 'suggest_link_over';
}

function suggestOut(div_value) {
	div_value.className = 'suggest_link';
}

function setSearch(value) {
	document.getElementById('diagnostic').value = value;
	document.getElementById('search_suggest').innerHTML = '';
}

/**
 *
 * @access public
 * @return void
 **/
function invalidArea(){
  alert("Invalid Area.");
}