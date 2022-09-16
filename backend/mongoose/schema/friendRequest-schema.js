const mongoose=require('mongoose');
const friendRequestSchema=new mongoose.Schema({
    sender:String,
    receiver:String,
    sendAt:{
        type:Date,
        default:Date.now()
    }
})
module.exports=friendRequestSchema;