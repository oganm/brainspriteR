#' @export
brainsprite = function(sprites,
                       spriteHeight = 233,
                       spriteWidth = 189,
                       id = tempfile() %>% basename,
                       spriteID = tempfile() %>% basename,
                       overlay = NULL,
                       overlayHeight = NULL,
                       overlayWidth = NULL,
                       overlayID = tempfile() %>% basename,
                       overlayOpacity = 0.5,
                       height = NULL,
                       width = NULL){

    script = glue::glue(" $( window ).load(function() {
                       var brain = brainsprite({
                       canvas: '[id]', // That is the ID of the canvas to build slices into
                       sprite: '[spriteID]', // That is the ID of the sprite image that includes all (sagital) brain slices
                       nbSlice: { 'Y':[spriteHeight] , 'Z':[spriteWidth] }"
                       ,.open = '[',.close = ']')

    if(!is.null(overlay)){
        script = glue::glue(script,",
                   overlay: {
                       sprite: '[overlayID]',
                       nbSlice:  { 'Y':[overlayHeight] , 'Z':[overlayWidth] }
                   }",.open = '[',.close = ']')
    }

    end = "});
});"

    script = paste0(script,end)

    out = htmltools::tagList(htmltools::div(
        glue::glue('<canvas id="{id}">') %>% htmltools::HTML(),
        htmltools::img(id = spriteID,src = sprites, class = 'hidden'),
        htmltools::img(id = overlayID,src = overlay, class = 'hidden'),
        height = height,
        width = width),
        htmltools::includeScript(system.file('inst/brainsprite/brainsprite.js',package = 'brainspriteR')),
        htmltools::includeScript(system.file('inst/brainsprite/jquery.min.js',package = 'brainspriteR')),
        htmltools::tags$script(script

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
