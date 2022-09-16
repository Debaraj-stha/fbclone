const mongoose = require("mongoose");
const storySchema = new mongoose.Schema({
  storys:[{
    type:{
      type:String,
      default:"photo"
    },
    story:String
  }],
  email:String,
  addedAt:{
    type:Date,
    default:Date.now()
  },
  views:Number,
  likes:[{
    email:String,
    types:String
  }]
  
});
module.exports=storySchema;