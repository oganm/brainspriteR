#' @export
brainsprite = function(sprites,
                       spriteHeight = 233,
                       spriteWidth = 189,
                       inputId = tempfile('id') %>% basename,
                       spriteID = tempfile('id') %>% basename,
                       flagCoordinates = FALSE,
                       origin = c(0,0,0),
                       fontColor = "#FFFFFF",
                       background = "#000000",
                       overlay = NULL,
                       overlayHeight = NULL,
                       overlayWidth = NULL,
                       overlayID = tempfile('id') %>% basename,
                       overlayOpacity = 0.5,
                       height = NULL,
                       width = NULL){

    script = glue::glue(" $( <spriteID> ).load(function() {
                       var brain = brainsprite({
                       canvas: '<inputId>', // That is the ID of the canvas to build slices into
                       sprite: '<spriteID>', // That is the ID of the sprite image that includes all (sagital) brain slices
                       nbSlice: { 'Y':<spriteHeight> , 'Z':<spriteWidth> },
                       colorBackground: '<background>',
                       colorFont: '<fontColor>',
                        flagCoordinates: <tolower(flagCoordinates)>,
                        origin: {X: <origin[1]>, Y: <origin[2]>, Z: <origin[3]>},
                        onclick: function shinyUpdate(brain){
                            Shiny.onInputChange('<inputId>',[brain.coordinatesSlice.X,brain.coordinatesSlice.Y ,brain.coordinatesSlice.Z])
                        }"
                       ,.open = '<',.close = '>')

    if(!is.null(overlay)){
        script = glue::glue(script,",
                   overlay: {
                       sprite: '<overlayID>',
                       nbSlice:  { 'Y':<overlayHeight> , 'Z':<overlayWidth> }
                   }",.open = '<',.close = '>')
    }

    end = "});
});"

    script = paste0(script,end)

    out = htmltools::tagList(htmltools::div(
        glue::glue('<canvas id="{inputId}">') %>% htmltools::HTML(),
        htmltools::img(id = spriteID,src = sprites),
        htmltools::img(id = overlayID,src = overlay),
        height = height,
        width = width),
        htmltools::includeScript(system.file('brainsprite/brainsprite.js',package = 'brainspriteR')),
        htmltools::includeScript(system.file('brainsprite/jquery.min.js',package = 'brainspriteR')),
        htmltools::tags$script(script))

    class(out) = append('brainsprite',class(out))

    return(out)
}

#' @export
print.brainsprite = function(x){
    tempFile <- tempfile()
    tempFile = 'hede.html'
    viewer <- getOption("viewer")
    writeLines(paste0('<html>\n',as.character(x),'\n</html>'),tempFile)
    viewer(tempFile)
}
