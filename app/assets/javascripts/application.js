// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function onload(){
 	form = document.getElementById("search_user")
 	form.addEventListener('submit',function(event){
 		console.log("tried submitting");
 		event.preventDefault();
 		var url ="/groups/searchuser";
 		var content = document.getElementById("search_user_name");
 		var data ={
 			content: content.value
 		}
 		if(!content.value || (content.value && content.value.length < 1)){
 			console.log("cannot search null");
 			return;
 		}
 		$.ajax({
 			url: url,
 			method: "POST",
 			data: data,
 			success: function(result){
 				console.log(result);
 				$("#search_user_div").empty();
 				for(var i = 0; i < result.length; i++){
 					$("#search_user_div").append("<div><h2>"+result[i].user_name+"<h2></div>")
 				};
 			},
 			error: function(error){
 				console.log("error");
 			}
 		});

 	});
	
};

window.addEventListener('load',onload);