#' @export
brainsprite = function(sprites,
                        spriteHeight = 233,
                        spriteWidth = 189,
                        id = '3Dviewer',
                        spriteID = 'spriteImg',
                        height = NULL,
                        width = NULL){

    out = htmltools::tagList(htmltools::div(
        glue::glue('<canvas id="{id}">') %>% htmltools::HTML(),
        htmltools::img(id = spriteID,src = sprites, class = 'hidden'),
        height = height,
        width = width),
        htmltools::includeScript(system.file('inst/brainsprite/brainsprite.js',package = 'brainspriteR')),
        htmltools::includeScript(system.file('inst/brainsprite/jquery.min.js',package = 'brainspriteR')),
        htmltools::tags$script(
            glue::glue(" $( window ).load(function() {
                       var brain = brainsprite({
                       canvas: '[id]', // That is the ID of the canvas to build slices into
                       sprite: '[spriteID]', // That is the ID of the sprite image that includes all (sagital) brain slices
                       nbSlice: { 'Y':[spriteHeight] , 'Z':[spriteWidth] }
                       });
});",.open = '[',.close = ']')
        ))

    class(out) = append(class(out),'brainsprite')

    return(out)
}


print.brainsprite = function(x){
    tempFile <- tempfile()
    tempFile = 'hede.html'
    viewer <- getOption("viewer")
    writeLines(paste0('<html>\n',as.character(x),'\n</html>'),tempFile)
    viewer(tempFile)
}
