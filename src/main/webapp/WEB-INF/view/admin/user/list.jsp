<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="kfs" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="asset"  uri="/WEB-INF/asset-tags/asset.tld"%>
    
<!DOCTYPE html>
<html>
<head>
<!-- =================================================== -->
<jsp:include page="../../common/meta_css.jsp" flush="false" />
<!-- =================================================== -->
<title><c:out value="${pageTitle}" default="용어사전" /></title>
<style>
.table tbody tr.highlight td {
  background-color: #EAF0F7;
}
</style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../../common/header.jsp" flush="false" />
<!-- =================================================== -->
<main class="container mx-3 my-3">
	<h2><i class="fa-solid fa-cube my-3"></i> USER LIST</h2>
  
	<div class="container-lg p-3 border border-2 rounded-1">
		<input type="text" class="form-control w-50 d-inline align-middle" placeholder="검색어를 입력하세요" id="searchText" name="searchText" value="${param.searchText}">
		<a class="btn d-inline align-middle btn-primary btnRetrieve"><i class="fa-solid fa-search"></i> 조회</a>
        <a class="btn d-inline align-middle btn-success" href="/admin/user/insert"><i class="fa-solid fa-pencil-alt"></i> 등록</a>
	</div>

	<table class="mt-3 table table-hover table-sm dictTable" style="font-size:small">
	  <thead class="table-light">
	    <tr class="text-center">
	      <th scope="col" style="width:50px">No</th>
          <th scope="col" >User ID</th>
	      <th scope="col" >User Name</th>
          <th scope="col" >User Email</th>
          <th scope="col" >User Tel</th>
          <th scope="col" style="width:150px"> </th>
	    </tr>
	  </thead>
	  <tbody class="table-group-divider" >
	  	<c:forEach var="list" items="${list}" varStatus="status">
		    <tr class="align-middle">
		      <td scope="row" class="text-center fw-bold">${status.count}</td>
              <td class="sys01UserId text-center">${list.sys01UserId}</td>
		      <td class="sys01UserNm text-center">${list.sys01UserNm}</td>
		      <td class="sys01UserEmail text-center">${list.sys01UserEmail}</td>
              <td class="sys01UserTel text-center">${list.sys01UserTel}</td>
              <td align="right">
                  <button class="btn btn-primary btn-sm btnModify" data-bs-target="#modalUser"><span><i class="fa-regular fa-pen-to-square"></i></span> 수정</button>
                  <button class="btn btn-danger btn-sm btnDelete" data-user-id="${user.sys01UserId }" data-user-nm="${user.sys01UserNm }"><span><i class="fa-regular fa-trash-can"></i></span> 삭제</button>
		       </td>
		    </tr>
	    </c:forEach>
	  </tbody>
	</table>
</main>

<!-- =================================================== -->
<jsp:include page="../../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script type="text/javascript" src="/js/input-format.js"></script>

<script>
$(document).ready(function () {
	console.log('용어사전 리스트...ready');
	
	let validateChecker = $('form.validcheck').jbvalidator({
        language: '/js/validation/lang/ko.json'
    });
	
	//화면뜨면 검색창에 포커스 
	$("#searchText").focus();
	
	//검색창에서 enter이면 조회
	$("#searchText").on("keyup",function(key){
        if(key.keyCode==13) { //enter
        	$('.btnRetrieve').trigger('click');
        }else if(key.keyCode == 46){ //DEL
        	$(this).val('');
        }
	});	

    //테이블 클릭시 하이라이트 표시
    $('.dictTable').on('click', 'tbody tr', function(event) {
          $(this).addClass('highlight').siblings().removeClass('highlight');
    });
	
	//조회버튼
	$('.btnRetrieve').on('click', function(){
		var searchText = $('#searchText').val();
		AssetUtil.submitGet('/admin/dict/list', {searchText : searchText});	
	});
	
	//초기화
	$('.btnInit').on('click', function(){
		AssetUtil.submitGet('/admin/dict/list', {searchText : null});	
	});
	
	//등록 modal show form
    $('.btnInsert').on('click', function(){
    	var $modal = $('#modalDict');
    	
        $modal.find('#formMode').val('insert');
        $modal.find('.modal-title').text('용어등록');
        
    	$modal.find('input[name=sys02Short]').val('');
    	$modal.find('input[name=sys02Full]').val('');
    	$modal.find('input[name=sys02KorNm]').val('');
    	$modal.find('input[name=sys02Note]').val('');
    	
    	//valid class remove
//         $('#formModalDict').find('div.invalid-feedback').hide()
//         $('#formModalDict').find('input.is-invalid').removeClass('is-invalid');
    	
    	$('#modalDict').modal('show');
    });

    //수정 modal show form
	$('.btnModify').on('click', function(){
		
		$modal = $('#modalDict');
		$tr = $(this).closest('tr');
        
        $modal.find('#formMode').val('update');
        $modal.find('.modal-title').text('용어수정');

        var val = $tr.find('.sys02DictId').text();
        $modal.find('input[name=sys02DictId]').val(val);

        var val = $tr.find('.sys02Short').text();
        $modal.find('input[name=sys02Short]').val(val);

        var val = $tr.find('.sys02Full').text();
        $modal.find('input[name=sys02Full]').val(val);

        var val = $tr.find('.sys02KorNm').text();
        $modal.find('input[name=sys02KorNm]').val(val);
        
        var val = $tr.find('.sys02Note').text();
        $modal.find('textarea[name=sys02Note]').val(val);
        
        $('#modalDict').modal('show');
	});

	//저장 submit
	$('#btnUpdate').on('click', function(){

		var $modal = $('#modalDict');
		var $form = $('#formModalDict');
		
        var validateChecker = $form.jbvalidator({
            language: '/js/validation/lang/ko.json'
        });
        var errorCount = validateChecker.checkAll($form);
        if(errorCount > 0)return;
	
        var mode = $modal.find('#formMode').val();
        var url = '/admin/dict/' + mode;
        var dictId = $('#formModalDict input[name=sys02DictId]').val();
        
        var json = AssetUtil.formToJson($('#formModalDict'));
        json = JSON.stringify(json);
        AssetUtil.ajax(url, json, {method:'POST', success:(response)=>{
        	if(response.result == 'OK'){
        		alert(response.msg);
        		AssetUtil.submitGet('/admin/dict/list', {lastDictId : response.lastDictId});
        	} else {
        		alert("실패하였습니다. " + response.result);
        	}
        }});
	});

	//서버로부터받은 DictId로 하이라이트
	var lastDictId = '<%=request.getParameter("lastDictId")%>';
	if(lastDictId != 'null'){
		$(".dictTable tr td").filter(function(){ return $(this).text() == lastDictId}).click();
	}

	//삭제 submit
	$('.btnDelete').on('click', function(e){
		e.stopPropagation();
		
		var shortCd = $(this).data('short');
		var dictId = $(this).data('dict-id');
		
		var msg = "\"" + shortCd + "\"를 삭제하시겠습니까?";
		if(confirm(msg)){
			AssetUtil.submitGet('/admin/dict/delete', {dictId:dictId});
		}
	});

}); 
</script>
</body>
</html>