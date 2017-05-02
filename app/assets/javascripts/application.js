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
// require turbolinks
//= require jquery-ui
//= require autocomplete-rails
//= require_tree .
//= require jquery
//= require bootstrap-sprockets

function onload(){

	console.log("loaded");
 	form = document.getElementById("search_user")
 	if(form){
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
	 				$("#result").empty();
	 				for(var i = 0; i < result.length; i++){
	 					var div_id = "user_id:" + result[i].id;
	 					// console.log(div_id);
	 					$("#result").append("<div class='search' id="+div_id+"><h2>"+result[i].user_name+"</h2></div>");
	 					var div = "#" + div_id;
	 					var add_event = document.getElementById(div_id);
	 					add_event.addEventListener("click",function(event){
	 						// console.log("clicked");
	 						event.preventDefault();
	 						// console.log(this.firstChild.innerHTML);
	 						var user_namee = this.firstChild.innerHTML;
	 						var group_id = this.parentNode.getAttribute('class').slice(9);
	 						// console.log(group_id);
	 						var user_id = this.getAttribute('id').slice(8);
	 						// console.log(user_id);
	 						var data ={
					 			user_id: user_id ,
					 			group_id: group_id	
					 		}
					 		var url = "/add_user";
					 		$.ajax({
					 			url: url,
					 			method: "POST",
					 			data: data,
					 			success: function(result){
					 				if(result === null){
					 					console.log("you are not admin of the group");
					 					return;
					 				}
									var user_id = "user_id:"+ result.user_id;
									var div = GetElementInsideContainer("group_users", user_id);
									// console.log(div);
									if(!div){
				 						$("#group_users").prepend("<div id="+user_id+"><h2>"+user_namee+"</h2></div>");
				 						var group_user = GetElementInsideContainer("group_users", user_id);
				 						group_user.addEventListener("click",remove_user);
				 					}else{
				 						console.log("already present");
				 					}

				 				},
					 			error: function(error){
				 					console.log(error);	
				 				}

					 		});


	 					});
	 					// $(div_id).click(function(){
	 					// 	event.preventDefault();
	 					// 	console.log("***");
	 					// 	console.log($(this).children("h2:first").html());
	 					// 	var user_namee = $(this).children("h2:first").html();
	 					// 	var group_id = $(this).parent().prop('className').slice(9);
	 					// 	var user_id = this.id.slice(8);
	 					// 	console.log("group_id: "+ group_id);
	 					// 	console.log("user_id: "+ this.id.slice(8));
					 	// 	var data ={
					 	// 		user_id: user_id ,
					 	// 		group_id: group_id	
					 	// 	}
					 	// 	var url = "/add_user";
					 	// 	$.ajax({
					 	// 			url: url,
					 	// 			method: "POST",
					 	// 			data: data,
					 	// 			success: function(result){
					 	// 				var user_id = result.user_id;
					 	// 				$("#group_users").prepend("<div id="+user_id+"><h2>"+user_namee+"</h2></div>");
					 	// 				console.log("done");

					 	// 			},
					 	// 			error: function(error){
					 	// 				console.log(error);
					 	// 			}

					 	// 		});

	 					// });


	 				};
	 			},
	 			error: function(error){
	 				console.log("error");
	 			}
	 		});

	 	});
	}
	var added =0;
	var add_public_contestant = document.getElementById("add_public_contestant");
	if(add_public_contestant){
		add_public_contestant.addEventListener('click',function(){
			console.log("clicked!");
			event.stopPropagation();
			event.preventDefault();
			added++;
			var id = "added:" + added;
			contestant_element = "<div><label for='contestant_name'>Contestant name</label><input type='text' name='contestant_name[]' class='added_contestant_name'><span id="+id+">delete</span><br></div>";
			$(contestant_element).insertBefore("#submit");
			var delete_icon = document.getElementById(id);
			delete_icon.addEventListener('click', function(){
				var parent = this.parentNode;
				this.parentNode.parentNode.removeChild(parent);
			});
		});
	}

 	var group_users =  document.getElementById("group_users");
 	if(group_users){
 		group_users = group_users.getElementsByTagName("div");
 	}
 	if(group_users){
 		for(var i = 0 ;i < group_users.length ; i++){
 			group_users[i].addEventListener("click",remove_user);
 		}
 	}

 	function remove_user(event){
 		event.stopPropagation();
 		console.log("*****");
 		console.log(this);
 		var url = "/remove_user";
 		var group_id = this.parentNode.getAttribute('class').slice(9);
 		var user_id = this.getAttribute('id').slice(8);
 		var data ={
			user_id: user_id ,
		    group_id: group_id	
		};
		console.log(group_id);
		console.log(user_id);
		console.log(data);
 		$.ajax({
			url: url,
			method: "POST",
			data: data,
			success: function(result){
				if(result === null){
					console.log("you are not the admin of the group");
					return;
				}
				console.log(result);
				var user_id = "user_id:" + result.user_id; 
				var user_div = GetElementInsideContainer("group_users",user_id);
				user_div.parentNode.removeChild(user_div);

			},
			error: function(error){
			 	console.log(error);	
			}

		});

 	};

 	var vote_form = document.getElementById("vote_form")
 	if(vote_form){
 		console.log("tag");
 		vote_form.addEventListener("submit", function(event){
 			event.preventDefault();
 			if ($('input[name=your_fav]:checked').length) {
           		vote_form.submit();
      		}
      		else {
           		console.log("Atleast one is to be selected"); 
      		}
 		});
 	}

	
};
function GetElementInsideContainer(containerID, childID) {
    var elm = null;
    var elms = document.getElementById(containerID).getElementsByTagName("*");
    console.log(elms);
    for (var i = 0; i < elms.length; i++) {
        if (elms[i].id === childID) {
            elm = elms[i];
            break;
        }
    }
    return elm;
}
window.addEventListener('load',onload);