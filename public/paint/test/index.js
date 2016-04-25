$(document).ready(function() {
    new ChickenPaint({
        uiElem: document.getElementById("chickenpaint-parent"),
        //loadImageUrl: "./uploaded.png",
        //loadChibiFileUrl: "/1.chi",
        saveUrl: '/posts/save',
        postUrl: '/posts/save',
        exitUrl: "/",
        allowSave: true,
        resourcesRoot: "../resources/"
    });
});
