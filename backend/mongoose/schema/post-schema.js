const mongoose = require("mongoose");
const { v1: uuidv4, v2: uuidv6 } = require("uuid");
const postSchema = new mongoose.Schema({
  userId: String,
  email: String,
  posts: [
    {
      postType: String,
      post: String,
    },
  ],
  postAt: {
    type: Date,
    default: Date.now(),
  },
  status: String,
  comments: [
    {
      email: String,
      commentText: String,
      commentImage: String,
      isNotified: {
        type:Boolean,
        default: false,
      },
      isImage:{
        type:Boolean,
        default: false
      },
      commentAt: {
        type: Date,
        default: Date.now(),
      },
      isShown: {
        type: Boolean,
        default: false,
      },
      commentReplys: [
        {
          
          email: String,
          replyText: String,
          replyImage: String,
          
          isNotified: {
            type:Boolean,
            default:false,
          },
          isImage:{
            type:Boolean,
            default:false
          },
          replyAt: {
            type: Date,
            default: Date.now(),
          },
          replyLikes: [
            {
              userId: {
                type: String,
              },
              isNotified: Boolean,
              email: String,
            },
          ],
        },
      ],
      commentLikes: [
        {
          isNotified:{
            type:Boolean,
            default: false
          },
          email: String,
        },
      ],
      
    },
  ],
  likes: [
    {
      userId: String,
      isNotified: {
        type: Boolean,
        default: false,
      },
      email: String,
      types: String,
    },
  ],
  email: String,
  reaction: [String],
});
module.exports = postSchema;
