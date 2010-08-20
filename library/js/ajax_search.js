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

		var url = webroot + '/library/eapi.php?search=' + str;

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
		ss.innerHTML += '<a href="#" onclick="javascript:closeSearch();">Close</a>';
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

/**
 *
 * @access public
 * @return void
 **/
function closeSearch(){
  var ss = document.getElementById('search_suggest');
  ss.innerHTML = '';
}