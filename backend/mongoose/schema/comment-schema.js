const mongoose=require('mongoose');
const { 
    v1: uuidv1,
    v4: uuidv4,
  } = require('uuid')
const commentSchema=new mongoose.Schema({
    postId:{
        type:String
    },
    comments:[
        {
        userrId:{
            type:String,
        },
        commentText:String,
        commentImage:String,
        isNotified:Boolean,
        commentAt:{
            type:Date,
            default:Date.now()
        },
        commentReply:[{
            userId:{
                type:String
            },
            replyText:String,
           replyImage:String,
           isNotified:{
                dafault:false,
                type:Boolean
           },
           replyAt:{
            type:Date,
            default:Date.now()
           },
           replyLike:[{
            userId: { 
                type: String,
                 },
                 isNotified:{
                    type:Boolean,
                    dafault:false,
                }
            }
            ]
        }],
       commentLikes:[{
            userId: { 
                type: String
                 },
                 isNotified:{
                    type:Boolean,
                    dafault:false
                 }
                }],
           commentId:{
            type:String,
            default:uuidv4()
           }
    }
]

})
module.exports=commentSchema;