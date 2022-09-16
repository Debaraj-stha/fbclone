const express = require("express");
const userModel = require("../mongoose/model/usermodel");
const router = express.Router();
const postModel = require("../mongoose/model/postmodel");

const commentModel = require("../mongoose/model/commentmodel");
const friendRequestModel = require("../mongoose/model/friendRequestModel");
const multer = require("multer");
const storyModel = require("../mongoose/model/storyModel");
router.get("/", (req, res) => {
  res.send("success");
});
router.post("/login", async (req, res) => {
  const password = req.body.password;
  // const hashpassword=await bcrypt(password,10);
  console.log(req.body);
  userModel.find(
    { email: req.body.email, phone: req.body.phone },
    async (err, doc) => {
      console.log(doc.length);
      if (!doc.length) {
        //   if (req.files) {
        //     console.log(req.files);
        //     res.send(req.files);
        //     const file = req.files.file;
        //     const filename = file.name;
        //     file.mv("../images/profile" + filename, (err) => {
        //       if (err) res.send(err);
        //       else {
        //         res.send("file uploaded");
        //       }
        //     });
        const user = new userModel({
          name: req.body.name,
          email: req.body.email,
          phone: req.body.phone,
          profile: req.body.profile,
          dob: req.body.dob,
          password: password,
        });
        await user.save((err, doc) => {
          if (err) {
            res.json({ message: "error" });
          }
          // else res.json(doc);
          else if (doc) {
            res.send(doc);
          } else res.json(doc);
        });
        // } else {
        //   res.send("no file");
        // }
      } else {
        res.json({ message: "exits" });
      }
    }
  );
});
router.post("/post", async (req, res) => {
  const post = new postModel({
    userId: req.body.userId,
    status: req.body.status,
    posts: req.body.posts,
    comments: req.body.comments,
    likes: req.body.likes,
  });
  console.log(req.body.posts);
  await post.save((err, doc) => {
    if (err) res.json({ message: err });
    else res.json(doc);
  });
});

router.post("/comment", async (req, res) => {
  const postId=req.body.postId;
  const email=req.body.email;
  const commentText=req.body.commentText;
  // postModel.findById(postId).then((post)=>{
  //   if(post){
  //       post.comments=post.comments.push({
  //         email:email,
  //         commentText:commentText
  //       })
  //        post.save((err,doc)=>{
  //         if(err)
  //         res.send(err)
          
  //         console.log(doc)
  //       })
  //       console.log("found")
  //   }
  //   else{
  //     res.status(404).send("post not found");
  //   }
  // }).catch((error)=>{
  //   res.status(501).send(error.message)
  // })
  postModel.updateOne(
    { _Id: postId },
    {
      $push: {
        comments: {
          email: email,
          commentText: commentText,
        },
      },
    },
    (err, doc) => {
      if (err) res.send("error");
      else res.send("success");
      console.log(doc);
    }
  );
});
router.post("/commentlike", (req, res) => {
  const postId = req.body.postId;
  const commentId = req.body.commentId;
  const email = req.body.email;
  var message=" ";
  console.log(req.body);
  postModel
    .findById(postId)
    .then((post) => {
      if (post) {
        if (post.comments.find(comment => comment._id == commentId)) {
          post.comments.find(c => {
            if (c.commentLikes.find(a => a.email == email)) {
              c.commentLikes = c.commentLikes.filter(b => b.email != email);
               post.save((err, doc) => {
                
               
              });
              message ="unlike"
            
            } else {
              c.commentLikes.push({
                email: email,
              });
               post.save((err, doc) => {
               
               
              });
              message ="like"
            }
           
          });
        }
        res.send(message);
       message = " ";
      } else {
        res.status(404).send("post not found");
      }
    })
    .catch((e) => {
      res.status(501).send(e.message);
    });
});

router.post("/commentReply", function (req, res) {
  const commentId=req.body.commentId
  const postId=req.body.postId
  console.log(req.body)
  var message=" ";
  postModel.findById(postId).then((post)=>{
    if(post){
    if(post.comments.find(comment=>comment._id==commentId)){
      post.comments.find((com)=>{
        if(com._id==commentId){
          console.log(com)
          post.comments.commentReplys =  com.commentReplys.push({
            email: req.body.email,
            replyText:req.body.replyText
           })
           post.save((err,doc)=>{
            console.log("pushed")
          });
        }
      });
      message = "yse";
    }
    else{
      message = "no"
    }
    res.send(message);
    message = " "
    // post.comments.commentReplys=post.comments.commentReplys.push({
    //      email: req.body.email,
    //       replyText: req.body.replyText,
    // })
    // post.save((err, doc)=>{
    //   res.send(doc);
    // })
  }
  else{
    request.status(404).send("post not found")
  }
  }).catch((e)=>{
    res.status(501).send(e.message)
  })
  /*postModel.updateOne(
    {
      _Id: req.body.postId,
      "comments._Id": commentId,
    },
    {
      $push: {
        "comments.$[].commentReplys": {
          email: req.body.email,
          replyText: req.body.replyText,
        }
      },
    },
    (err, doc) => {
      if (err) res.send(err.message);
      else res.send(doc);
    }
  );*/
});
router.get("/replyLike", (req, res) => {
  let userId;
  let isNotified;
  req.body.replyLikes.map((e) => {
    userId = e.userId;
    isNotified = e.isNotified;
  });
  console.log(userId);
  postModel.find(
    {
      _Id: req.body.postId,
      "comments._Id": req.body.commentId,
      "comments.commentReplys.replyLikes.userId": userId,
    },
    (err, doc) => {
      if (!doc.length) {
        postModel.updateOne(
          {
            _Id: req.body.postId,
            "comments._Id": req.body.commentId,
            "comments.commentsReplys._Id": req.body.replyId,
          },
          {
            $push: {
              "comments.$[].commentReplys.$[].replyLikes": req.body.replyLikes,
            },
          },
          (err, doc) => {
            if (err) res.json({ message: err });
            else res.json(doc);
          }
        );
      } else {
        postModel.updateOne(
          {
            _Id: req.body.postId,
            "comments._Id": req.body.commentId,
            "comments.commentsReplys._Id": req.body.replyId,
          },
          {
            $pull: {
              "comments.$[].commentReplys.$[].replyLikes": {
                userId: userId,
                isNotified: isNotified,
              },
            },
          },
          (err, doc) => {
            if (err) res.json({ message: err });
            else res.json(doc);
          }
        );
      }
    }
  );
});
router.post("/friend_request_send", async (req, res) => {
  friendRequestModel.find(
    {
      sender: req.body.sender,
      receiver: req.body.receiver,
    },
    async (err, info) => {
      if (!info.length) {
        const request = new friendRequestModel({
          sender: req.body.sender,
          receiver: req.body.receiver,
        });
        await request.save((err, info) => {
          if (err) res.json({ message: "error" });
          else res.json(info);
        });
      } else if (err) res.json({ message: err });
      else {
        res.json({ message: "already send" });
      }
    }
  );
});

router.get("/request_receive", async (req, res) => {
  friendRequestModel.find({ receiver: req.body.receiver }, (err, doc) => {
    if (err) res.json({ message: "err" });
    else res.json(doc);
  });
});

router.get("/request_send", async (req, res) => {
  friendRequestModel.find({ sender: req.body.receiver }, (err, doc) => {
    if (err) res.json({ message: "err" });
    else res.json(doc);
  });
});

router.get("/dob", async (req, res) => {
  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth();
  const day = today.getDay();
  console.log(day);
  const id = [];
  const birthday = await userModel.aggregate([
    {
      $project: {
        year: { $year: "$dob" },
        month: { $month: "$dob" },
        day: { $dayOfMonth: "$dob" },
      },
    },
    {
      $match: { month: month, day: day },
    },
  ]);
  birthday.map((e) => {
    id.push(e._id);
  });
  // console.log(id);
  userModel.find({ _id: { $in: id } }, (err, doc) => {
    if (err) res.send({ message: "error" });
    else res.json(doc);
  });
});

router.post("/upload", (req, res) => {
  if (req.files.image) {
    res.status(200).json({ message: "succesaa" });
  } else {
    console.log("select an image");
  }
});
router.get("/posts", (req, res) => {
  postModel
    .aggregate([
      {
        $lookup: {
          from: "users",
          localField: "email",
          foreignField: "email",
          as: "user",
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "comments.email",
          foreignField: "email",
          as: "commentUser",
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "comments.commentReplys.email",
          foreignField: "email",
          as: "replyUser",
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "comments.commentReplys.replyLikes.email",
          foreignField: "email",
          as: "replyLikeUser",
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "likes.email",
          foreignField: "email",
          as: "likeUser",
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "comments.commentLikes.email",
          foreignField: "email",
          as: "commentlikeUser",
        },
      },
    ])
    .exec(function (err, docs) {
      if (err) throw err;
      // res.json(docs)
      let commentUser = [];
      // let comments = [];
      let likeUser = [];
      let commentReplyUser = [];
      let commentLikeUser = [];
      let likes = [];
      let replys = [];
      let comment = [];
      let arr = [];
      let postUser = [];
      let commentLikes = [];
      let replyLikesUser = [];
      let replyLikes = [];
      for (let i = 0; i < docs.length; i++) {
        //for post user

        docs[i].user.map((u) => {
          postUser.push({
            email: u.email,
            profile: u.profile,
            name: u.name,
          });
        });

        //for likes
        docs[i].likeUser.map((user) => {
          likeUser.push({
            email: user.email,
            profile: user.profile,
            name: user.name,
          });
        });
        for (let j = 0; j < docs[i].likes.length; j++) {
          let temp = likeUser.find((e) => e.email === docs[i].likes[j].email);
          if (temp.email) {
            docs[i].likes[j].email = temp.email;
            likes.push({
              user: {
                name: temp.name,
                email: temp.email,
                profile: temp.profile,
              },
              id: docs[i].likes[j]._id,
              isNotified: docs[i].likes[j].isNotified,
              types: docs[i].likes[j].types,
            });
          }
        }

        //for comments

        docs[i].commentUser.map((user) => {
          commentUser.push({
            email: user.email,
            profile: user.profile,
            name: user.name,
          });
        });

        //for comment reeplys
        docs[i].replyUser.map((user) => {
          commentReplyUser.push({
            email: user.email,
            profile: user.profile,
            name: user.name,
          });
        });

        //for comment likes
        docs[i].commentlikeUser.map((user) => {
          commentLikeUser.push({
            email: user.email,
            profile: user.profile,
            name: user.name,
          });
        });

        // for reply likes
        docs[i].replyLikeUser.map((user) => {
          replyLikesUser.push({
            email: user.email,
            profile: user.profile,
            name: user.name,
          });
        });
        for (let j = 0; j < docs[i].comments.length; j++) {
          let temp = commentUser.find(
            (e) => e.email === docs[i].comments[j].email
          );
          //replys
          for (let k = 0; k < docs[i].comments[j].commentReplys.length; k++) {
            for (
              let m = 0;
              m < docs[i].comments[j].commentReplys[k].replyLikes.length;
              m++
            ) {
              let replylike =
                docs[i].comments[j].commentReplys[k].replyLikes[m];
              let tem = replyLikesUser.find((e) => e.email === replylike.email);

              if (tem.email) {
                replylike.email = tem.email;
                replyLikes.push({
                  user: {
                    email: tem.email,
                    name: tem.name,
                    profile: tem.profile,
                  },
                  isNotified: replylike.isNotified,
                  _id: replylike._id,
                });
              }
            }
            let rep = docs[i].comments[j].commentReplys[k];
            let temp = commentReplyUser.find((e) => e.email === rep.email);
            if (temp.email) {
              rep.email = temp.email;
              replys.push({
                user: {
                  name: temp.name,
                  email: temp.email,
                  profile: temp.profile,
                },
                isNotified: rep.isNotified,
                replyText: rep.replyText,
                replyAt: rep.replyAt,
                replyLikes: replyLikes,
                _id: rep._id,
              });
            }
            replyLikes = [];
          }
          for (let l = 0; l < docs[i].comments[j].commentLikes.length; l++) {
            let like = docs[i].comments[j].commentLikes[l];
            let temp = commentLikeUser.find((e) => e.email === like.email);
            if (temp.email) {
              like.email = temp.email;
              commentLikes.push({
                user: {
                  name: temp.name,
                  email: temp.email,
                  profile: temp.profile,
                },
                isNotified: like.isNotified,
                _id: like._id,
                // types:like.types
                // likeAt:like.likeAt
              });
            }
          }
          if (temp.email) {
            docs[i].comments[j].email = temp.email;
            let c = docs[i].comments[j];
            comment.push({
              user: {
                name: temp.name,
                email: temp.email,
                profile: temp.profile,
              },
              commentText: c.commentText,
              commentAt: c.commentAt,
              isNotified: c.isNotified,
              _id: c._id,
              reply: replys,
              commentlikes: commentLikes,
            });
          }
          replys = [];
          commentLikes = [];
        }
        // comments.push(comment);
        arr.push({
          status: docs[i].status,
          postAt: docs[i].postAt,
          posts: docs[i].posts,
          postId: docs[i]._id,
          likes: likes,
          comments: comment,
          user: postUser,
          reaction: docs[i].reaction,
        });
        likes = [];
        comment = [];
      }

      res.json(arr);
    });
});

router.get("/users", function (req, res) {
  postModel.find({}, (err, doc) => {
    res.json(doc);
  });
});
router.post("/user", (req, res) => {
  userModel.find({ email: req.body.email }, (err, doc) => {
    if (err) res.json({ message: err });
    else res.json(doc);
    console.log(doc);
  });
});
router.post("/getcomments", (req, res) => {
  commentModel.find();
});
router.post("/like", (req, res) => {
  const postId = req.body.postId;
  const userId = req.body.userId;
  const email = req.body.email;
  const reaction = req.body.reaction;
  postModel
    .findById(postId)
    .then((post) => {
      if (post) {
        if (post.reaction.indexOf(reaction) !== -1) {
          // post.reaction.pull(reaction);
          post.save((err, doc) => {
            console.log("exits");
          });
        }
        if (post.likes.find((like) => like.userId == userId)) {
          post.likes = post.likes.filter((like) => like.userId != userId);
          return post.save((_) => {
            res.send("unlike");
          });
        } else {
          post.likes.push({
            userId: userId,
            email: email,
            types: req.body.types,
          });
          post.reaction.push(reaction);
          return post.save((_) => {
            res.send("like");
            console.log("pushed");
          });
        }
      } else {
        res.status(404).send("post not found.");
      }
    })
    .catch((err) => {
      console.log(err.message);
      res.send("an error occurred");
    });
});
router.post("/reaction", (req, res) => {
  const postId = req.body.postId;
  const reaction = req.body.reaction;
  postModel
    .findById(postId)
    .then((post) => {
      if (post) {
        if (post.reaction.indexOf(reaction) !== -1) {
          res.send("exits");
        } else {
          post.reaction.push(reaction);

          return post.save((err, doc) => {
            res.send(doc);
            console.log("pushed");
          });
        }
      } else {
        res.status(404).send("post not found.");
      }
    })
    .catch((err) => {
      console.log(err);
    });
});

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "././upload/");
  },
  filename: function (req, file, cb) {
    cb(
      null,
      "upload" + "-" + Date.now() + "." + file.originalname.split(".")[1]
    );
  },
});

const upload = multer({ storage: storage }).single("file");
router.post("/uploader", function (req, res) {
  upload(req, res, function (err) {
    if (err) {
      res.send(err.message);
    } else {
      res.send("uploaded");
    }
  });
  //  res.send(req.file)
  console.log(req.file, req.body);
});
router.post("/story", async (req, res) => {
  const story=new storyModel({
    storys: req.body.storys,
    email: req.body.email,
    views: req.body.views,
    likes:req.body.likes
  })
  await story.save((err, doc)=>{
    if(err)
    res.send(err.message);
    else res.send(doc);
  })
})
router.get("/story",(req, res)=>{
  let storyUser=[];
  let likedUser=[];
  let likes=[];
  let story=[];
  storyModel.aggregate([
    {
      $lookup: {
        from: "users",
        localField: "email",
        foreignField: "email",
        as: "user",
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "likes.email",
        foreignField: "email",
        as: "likeUser",
      },
    }
  ]).exec((err,docs)=>{
    
    for(var i=0;i<docs.length;i++){  
      docs[i].user.map((u)=>{
        storyUser.push({
          name: u.name,
          email: u.email,
          profile: u.profile
        })
      })
      docs[i].likeUser.map((user) => {
        likedUser.push({
          email: user.email,
          profile: user.profile,
          name: user.name,
        });
      });
      for (let j = 0; j < docs[i].likes.length; j++) {
        let temp = likedUser.find((e) => e.email === docs[i].likes[j].email);
        
        if (temp.email) {
          docs[i].likes[j].email = temp.email;
          likes.push({
            user: {
              name: temp.name,
              email: temp.email,
              profile: temp.profile,
            },
            id: docs[i].likes[j]._id,
            type: docs[i].likes[j].type,
          });
        }
      }
      story.push({
        likes:likes,
        user:storyUser,
        story:docs[i].storys,
        views:docs[i].views,
        id: docs[i]._id,
        addedAt:docs[i].addedAt
      })
      likes=[];
      storyUser=[];
  }
  
  res.send(story)
  })
  
});
module.exports = router;
