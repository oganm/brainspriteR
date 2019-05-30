#' Brainsprite
#'
#' Creates an interactive 3D viewer for MRI slices.
#'
#' @param sprites File path for the spries
#' @param spriteHeight Height of the brain sprite tiles
#' @param spriteWidth Width of the brain sprite tiles
#' @param inputId Input ID for use in shiny applications
#' @param spriteID Id for the sprite image
#' @param flagCoordinates Show coordinates of the clicked position
#' @param origin Which voxel has the coordinates 0,0,0
#' @param fontColor Color of the text
#' @param background Background color
#' @param overlay File path for an optional overlay image
#' @param overlayHeight Height of the overlay sprite tiles
#' @param overlayWidth Width of the overlay sprite tiles
#' @param overlayID Id for the overlay image
#' @param overlayOpacity Opacity of the overlay image
#' @param height Height of the visualization
#' @param width Width of the visualization
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
        htmltools::htmlDependency('brainsprite',
                                  src = system.file('brainsprite',package = 'brainspriteR'),
                                  version = '1.0',
                                  script = c('brainsprite.js',
                                             'jquery.min.js')),
        htmltools::tags$script(script))

    attributes(out) = append(attributes(out), list(sprites = sprites,
                                                   overlay = overlay,
                                                   spriteID = spriteID,
                                                   overlayID = overlayID))
    class(out) = append('brainsprite',class(out))

    return(out)
}

#' @export
print.brainsprite = function(x, viewer = getOption("viewer", utils::browseURL)){
    www_dir <- tempfile("viewhtml")
    dir.create(www_dir)
    index_html <- file.path(www_dir, "index.html")
    attr = attributes(x)

    file.copy(attr$sprites,glue::glue("{www_dir}/sprites"))
    file.copy(attr$overlay,glue::glue("{www_dir}/overlay"))

    x[[1]]$children[[2]] = htmltools::img(id = attr$spriteID,src = 'sprites')

    if(!is.null(attr$overlay)){
        x[[1]]$children[[3]] = htmltools::img(id = attr$overlayID,src = 'overlay')
    }

    htmltools::save_html(x, file = index_html, background = 'white',
              libdir = "lib")
    if (!is.null(viewer))
        viewer(index_html)
    invisible(index_html)

}
