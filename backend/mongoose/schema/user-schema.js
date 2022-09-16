const mongoose=require('mongoose');
const userSchema=new mongoose.Schema({
    email:{
        type: String,
        trim: true,
        lowercase: true,
        unique: true,
    },
    name:String,
    phone:Number,
    profile:String,
    dob:Date,
    join_at:{
        type:Date,
        default:Date.now()
    },
    password:String,
});
module.exports=userSchema;