const {onDocumentCreated, onDocumentDeleted} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendLikeNotification = onDocumentCreated(
    "/posts/{postId}/likes/{uid}",
    async (event) => {
        const postId = event.params.postId;
        const uid = event.params.uid;
        const likeData = event.data.data();
        const postSnapshot = await admin.firestore().collection("posts").doc(postId).get();
        const post = postSnapshot.data();
        const authorId = post.uid;

        if (authorId === uid) {
            return;
        }

        const userSnapshot = await admin.firestore().collection("users").doc(authorId).get();
        const authorData = userSnapshot.data();
        const token = authorData.fcmToken;
        const message = {
            notification: {
                title: "새로운 좋아요",
                body: `${likeData.nickname}님이 게시물을 좋아합니다.\n확인해보세요 :)`,
            },
            token: token,
            data: {
                type: "like",
                postId: postId,
            },
        };

        await admin.messaging().send(message);

        const notification = {
            type: "like",
            postId: postId,
            userId: uid,
            message: `${likeData.nickname}님이 게시물을 좋아합니다.`,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.firestore().collection("users").doc(authorId).collection("notifications").add(notification);
    },
);

exports.sendCommentNotification = onDocumentCreated(
    "/posts/{postId}/comments/{commentId}",
    async (event) => {
        const postId = event.params.postId;
        const commentData = event.data.data();

        const postSnapshot = await admin.firestore().collection("posts").doc(postId).get();
        const post = postSnapshot.data();
        const authorId = post.uid;

        if (authorId === commentData.uid) {
            return;
        }

        const userSnapshot = await admin.firestore().collection("users").doc(authorId).get();
        const authorData = userSnapshot.data();
        const token = authorData.fcmToken;

        const message = {
            notification: {
                title: "새로운 댓글",
                body: `${commentData.nickname}님이 댓글을 남겼습니다: "${commentData.content}"`,
            },
            token: token,
            data: {
                type: "comment",
                postId: postId,
            },
        };

        await admin.messaging().send(message);

        const notification = {
            type: "comment",
            postId: postId,
            userId: commentData.uid,
            message: `${commentData.nickname}님이 댓글을 남겼습니다.`,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.firestore().collection("users").doc(authorId).collection("notifications").add(notification);
    },
);

exports.updateLikesCount = onDocumentCreated(
    "/posts/{postId}/likes/{uid}",
    async (event) => {
        const postId = event.params.postId;
        const postRef = admin.firestore().collection("posts").doc(postId);

        await postRef.update({
            likeCount: admin.firestore.FieldValue.increment(1),
        });
    },
);

exports.decreaseLikesCount = onDocumentDeleted("/posts/{postId}/likes/{uid}", async (event) => {
    const postId = event.params.postId;
    const postRef = admin.firestore().collection("posts").doc(postId);

    await postRef.update({
        likeCount: admin.firestore.FieldValue.increment(-1),
    });
});

exports.decreaseCommentsCount = onDocumentDeleted("/posts/{postId}/comments/{commentId}", async (event) => {
    const postId = event.params.postId;
    const postRef = admin.firestore().collection("posts").doc(postId);

    await postRef.update({
        commentCount: admin.firestore.FieldValue.increment(-1),
    });
});

exports.updateCommentCount = onDocumentCreated("/posts/{postId}/comments/{commentId}", async (event) => {
    const postId = event.params.postId;
    const postRef = admin.firestore().collection("posts").doc(postId);

    await postRef.update({
        commentCount: admin.firestore.FieldValue.increment(1),
    });
});
