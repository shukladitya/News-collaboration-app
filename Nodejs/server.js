const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");

const app=express();

app.use(bodyParser.urlencoded({extended:true}));

//mongodb server
mongoose.connect("mongodb+srv://todDB",{ useNewUrlParser: true },{ useUnifiedTopology: true });

const userSchema = {
	name:String,
	email:String,
	password:String,
	error:Number,
	status:String
};

const articleSchema = {
	date:String,
	title:String,
	imageurl:String,
	content:String,
	readurl:String,
	email:String,
	tag:String,
	approved:Number
};

const User = mongoose.model("User", userSchema);

const Article = mongoose.model("Article", articleSchema);

//all get requests below
app.get('/approvearticles',(req,res)=>{
	Article.find({approved:0}).sort('-date').exec((error,articles)=>{
		(!error)?res.send(articles):res.send(error);
	});
});


app.get('/dashboard',(req,res)=>{
	Article.find({approved:1}).sort('-date').limit(10).exec((error,articles)=>{
		(!error)?res.send(articles):res.send(error);
	});
});

app.post('/tagnews',(req,res)=>{
	Article.find({tag:req.body.tag}).sort('-date').exec((error,articles)=>{
		(!error)?res.send(articles):res.send(error);
	});
});

app.get('/tagnewsall',(req,res)=>{
	Article.find().sort('-date').exec((error,articles)=>{
		(!error)?res.send(articles):res.send(error);
	});
});

//all post requests below
app.post('/newuser',(req,res)=>{
	console.log(req.body);
	let ver = 0;
	User.find((error,users)=>{
		users.forEach((obj)=>{
			if(obj.email == req.body.email)
				ver = 1;
		});
	   if(ver == 0){
		    const newUser = new User({
					name: req.body.name,
					email: req.body.email,
					password: req.body.password,
					error: 0,
					status: "success"
		    });
		    console.log(newUser);
		    newUser.save((err)=>{
	    		if(err)
	    			res.send(err);
	    		else
	    			res.send(newUser);
	    	});
	    }
	    else
	    res.send(JSON.parse(`{"error":1,"status":"email already exist!"}`));
	});
});

app.post('/login',(req,res)=>{
	User.find({email:req.body.email},(error,user)=>{
		if(user.length!=0){
				if(user[0].password==req.body.password){
					res.send(user[0]);
				}
				else if(error){
					res.send(JSON.parse(`{"error":1,"status":${error}}`));
				}
				else
			    	res.send(JSON.parse(`{"error":1,"status":"password incorrect!"}`));
		}
		else
			res.send(JSON.parse(`{"error":1,"status":"email not found."}`));
	});
});

app.post('/newarticle',(req,res)=>{
	const newarticle = new Article({
			date : req.body.date,
			title : req.body.title,
			imageurl : req.body.imageurl,
			content : req.body.content,
			readurl : req.body.readurl,
			email : req.body.email,
			tag : req.body.tag,
			approved : 0
	});
	newarticle.save((err)=>{
	    		if(err)
	    			res.send(JSON.parse(`{"error":1,"status":${error}}`));
	    		else
	    			res.send(JSON.parse(`{"error":0,"status":"Saved successfully."}`));
	    	});

});

app.post('/authpass',(req,res)=>{
	if(req.body.pass!='jssnews@123')
		res.send(JSON.parse(`{"error":1,"status":"password incorrect"}`));
	else
	    res.send(JSON.parse(`{"error":0,"status":"password correct."}`));

});

app.post('/approvenews',(req,res)=>{
	Article.updateOne({_id : req.body.id}, {approved : 1}, (error)=>{
		if(error)
			res.send(JSON.parse(`{"error":1,"status":${error}}`));
		else
	    	res.send(JSON.parse(`{"error":0,"status":"Approved successfully."}`));
	});

});

app.post('/deletenews',(req,res)=>{
	Article.deleteOne({_id : req.body.id}, (error)=>{
		if(error)
			res.send(JSON.parse(`{"error":1,"status":${error}}`));
		else
	    	res.send(JSON.parse(`{"error":0,"status":"Deleted successfully."}`));
	});

});


//port and listen
let port = process.env.PORT;
if(port == null || port == ""){
	port = 3000;
}
app.listen(port,()=>{
	console.log(`server running at port ${port}`);
});